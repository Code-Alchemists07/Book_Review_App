Here’s the **updated README.md** with a new step added for creating a `terraform.tfvars` file containing your values:

---

# Book Review App

A simple **Flask-based Book Review Web Application** deployed on **Azure App Service**.
Users can:

* Submit book reviews (title, review text, optional book cover image)
* Store data in **Azure PostgreSQL**
* Store uploaded book covers in **Azure Blob Storage**
* View a list of submitted reviews on the homepage.

---

## **Architecture**

This app uses the following Azure components:

* **Azure App Service (Linux)** – Hosts the Flask application (using Gunicorn in production)
* **Azure PostgreSQL Flexible Server** – Stores reviews
* **Azure Storage Blob** – Stores uploaded book cover images
* **Terraform** – Infrastructure as Code for provisioning resources

---

## **Features**

1. Submit reviews with book title, review text, and optional book cover
2. View all reviews on the home page
3. Stores images in Azure Blob Storage
4. Uses PostgreSQL as backend database
5. Simple UI built with Bootstrap

---

## **Project Structure**

```
Book_Review_App/
│
|# Flask application
|
├── app.py
├── templates/
│   ├── index.html
│   └── add_review.html
└── requirements.txt
│
│
├── terraform/             # Terraform files for Azure resources
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars   # Your custom values (explained below)
│
└── README.md
```

---

## **Setup and Run Locally**

### **1. Prerequisites**

* Python 3.12
* PostgreSQL (local or Azure)
* Azure Storage Account (optional for local dev)
* Git

---

### **2. Clone the Repository**

```bash
git clone https://github.com/Code-Alchemists07/Book_Review_App.git
cd Book_Review_App/app
```

---

### **3. Create Virtual Environment & Install Dependencies**

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

---

### **4. Set Environment Variables**

Create a `.env` file or export variables manually:

```bash
export DB_CONNECTION="postgresql://<username>:<password>@<host>:5432/bookreviewdb"
export STORAGE_ACCOUNT="<storage_account_name>"
export STORAGE_KEY="<storage_account_key>"
```

---

### **5. Run the Flask App**

```bash
python app.py
```

Visit:

```
http://127.0.0.1:8000
```

---

## **Deploy to Azure with Terraform**

### **1. Move to terraform directory**

```bash
cd ../terraform
```

---

### **2. Create a `terraform.tfvars` file**

In the `terraform` folder, create a new file called `terraform.tfvars` and add:

```hcl
subscription_id      = <YOUR_SUBSCRIPTION_ID>
tenant_id            = <YOUR_TENANT_ID>
db_admin_password    = <DB_PASSWORD>
github_repo_url      = "https://github.com/YourUserName/your-repo-name"
```

This file allows Terraform to use your values without hardcoding them in `variables.tf`.

---

### **3. Initialize Terraform**

```bash
terraform init
```

---

### **4. Plan and Apply**

```bash
terraform plan
terraform apply -auto-approve
```

Terraform will:

* Create a Resource Group
* Create Azure App Service, PostgreSQL, Storage
* Configure environment variables
* **Enable deployment from your GitHub repository** using the following block in `azurerm_linux_web_app`:

```hcl
source_control {
  repo_url           = "https://github.com/YourUserName/your-repo-name"
  branch             = "main"
  manual_integration = false
}
```
This block automatically connects your Azure Web App to your GitHub repo for CI/CD.

---

### **5. Deploy Your Code**

If you are not using GitHub Actions (or for manual deployment):

```bash
cd ../app
zip -r app.zip .
az webapp deployment source config-zip \
  --resource-group bookreview-rg \
  --name bookreview-web-terraform \
  --src app.zip
```

---

## **Access the App**

Open the output URL from Terraform:

```
https://bookreview-web-terraform.azurewebsites.net
```

---

## **Web-App Overview**

### Home Page

Displays all reviews with optional book cover images.

### Add Review

Form to submit a new review.

---

## **Technology Stack**

* **Flask** (Python)
* **Azure App Service**
* **Azure PostgreSQL Flexible Server**
* **Azure Blob Storage**
* **Bootstrap 5**
* **Terraform**

---