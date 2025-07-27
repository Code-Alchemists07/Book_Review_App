from flask import Flask, render_template, request, redirect
import os
import psycopg2
from azure.storage.blob import BlobServiceClient
import logging
import uuid

# Setup logging
logging.basicConfig(level=logging.INFO)

app = Flask(__name__)

# Connect to Azure PostgreSQL using env variable
DB_CONN = os.getenv("DB_CONNECTION")
try:
    conn = psycopg2.connect(DB_CONN)
    logging.info("Connected to PostgreSQL database successfully.")
except Exception as e:
    logging.error(f"Failed to connect to PostgreSQL: {e}")
    raise

# Ensure the reviews table exists
try:
    with conn.cursor() as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS reviews (
                id SERIAL PRIMARY KEY,
                title TEXT,
                review TEXT,
                cover TEXT
            )
        """)
        conn.commit()
    logging.info("Ensured 'reviews' table exists.")
except Exception as e:
    logging.error(f"Error creating table: {e}")
    raise

# Connect to Azure Blob Storage using env variables
try:
    blob_service_client = BlobServiceClient.from_connection_string(
        f"DefaultEndpointsProtocol=https;AccountName={os.getenv('STORAGE_ACCOUNT')};"
        f"AccountKey={os.getenv('STORAGE_KEY')};EndpointSuffix=core.windows.net"
    )
    container_client = blob_service_client.get_container_client("bookcovers")
    logging.info("Connected to Azure Blob Storage container 'bookcovers'.")
except Exception as e:
    logging.error(f"Failed to connect to Blob Storage: {e}")
    raise

@app.route("/", methods=["GET"])
def index():
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT title, review, cover FROM reviews ORDER BY id DESC")
            rows = cur.fetchall()
        reviews = [{"title": r[0], "review": r[1], "cover": r[2]} for r in rows]
    except Exception as e:
        logging.error(f"Error fetching reviews: {e}")
        reviews = []

    return render_template("index.html", reviews=reviews, storage_account_name=os.getenv("STORAGE_ACCOUNT"))

@app.route("/add_review", methods=["GET", "POST"])
def add_review():
    if request.method == "POST":
        title = request.form.get("title")
        review = request.form.get("review")
        file = request.files.get("cover")

        cover_filename = None
        if file and file.filename:
            try:
                unique_filename = f"{uuid.uuid4()}_{file.filename}"
                blob_client = container_client.get_blob_client(unique_filename)
                blob_client.upload_blob(file, overwrite=True)
                cover_filename = unique_filename
                logging.info(f"Uploaded cover image to Blob Storage: {unique_filename}")
            except Exception as e:
                logging.error(f"Error uploading cover image: {e}")
                cover_filename = None

        try:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO reviews (title, review, cover) VALUES (%s, %s, %s)",
                    (title, review, cover_filename)
                )
                conn.commit()
            logging.info("Review saved to database.")
        except Exception as e:
            logging.error(f"Error saving review to database: {e}")

        return redirect("/")

    return render_template("add_review.html")


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)