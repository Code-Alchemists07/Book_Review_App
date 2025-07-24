from flask import Flask, render_template, request, redirect, url_for
from werkzeug.utils import secure_filename
import os

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'static/uploads'
app.config['MAX_CONTENT_LENGTH'] = 5 * 1024 * 1024  # 5 MB

# Sample in-memory storage
reviews = []

@app.route('/')
def index():
    return render_template('index.html', reviews=reviews)

@app.route('/add', methods=['GET', 'POST'])
def add_review():
    if request.method == 'POST':
        title = request.form['title']
        review = request.form['review']
        file = request.files['cover']

        filename = ""
        if file:
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

        reviews.append({
            'title': title,
            'review': review,
            'cover': filename
        })
        return redirect(url_for('index'))

    return render_template('add_review.html')

if __name__ == '__main__':
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
    app.run(debug=True)
