🧾 Flutter Desktop Billing Application

A cross-platform **Desktop Billing Management Application** built using Flutter and Dart, designed to simplify customer management, product management, invoice generation, payment tracking, and automated invoice delivery.

The application uses **Firebase** for backend data synchronization and integrates an automated email workflow for sending generated invoices to customers.

## 🚀 Project Overview

This application provides a centralized billing solution for managing:

* 👥 Customers
* 📦 Products
* 🧾 Invoices
* 💳 Payment records
* 📊 Sales and revenue
* 📧 Automated invoice emails
* ☁️ Firebase data synchronization
* 💾 Offline/local data storage

The application is designed with an **offline-first approach**, allowing billing operations to continue even when an internet connection is unavailable and synchronizing data with Firebase when connectivity is restored.

## ✨ Key Features

### 🔐 Authentication

* Secure application login
* Admin-oriented application access

### 📊 Dashboard

* Total customers
* Total invoices
* Pending payments
* Product sales
* Monthly revenue
* Quick access to major application modules

### 👥 Customer Management

* Add new customers
* Update customer information
* Search and manage customer records
* Maintain customer billing history

### 📦 Product Management

* Add and update products
* Product pricing management
* Stock/product information
* Product selection during invoice creation

### 🧾 Invoice Management

* Create and manage invoices
* Automatic invoice numbering
* Generate PDF invoices
* Calculate subtotal, taxes/charges, and total amount
* Print invoices
* Store generated invoices locally

### 📧 Automated Email System

* Automatically send invoices to customers
* Attach generated PDF invoices
* Email workflow integrated with the billing process
* Offline email queue handling

### 💳 Payment Tracking

* Record customer payments
* Track pending and completed payments
* Maintain payment history
* QR-based payment workflow

### ☁️ Firebase Integration

* Firebase backend integration
* Cloud data synchronization
* Sync local data with Firebase
* Retrieve updated data from Firebase

### 💾 Offline Support

* Local database storage
* Continue billing operations without internet connectivity
* Maintain pending synchronization tasks
* Synchronize data when connectivity is restored

---

## 🏗️ Application Architecture

The application follows a modular architecture to keep the code maintainable and scalable.

```text
lib/
│
├── models/
│   ├── customer.dart
│   ├── product.dart
│   ├── invoice.dart
│   └── payment.dart
│
├── providers/
│   ├── customer_provider.dart
│   ├── product_provider.dart
│   ├── invoice_provider.dart
│   └── payment_provider.dart
│
├── screens/
│   ├── login/
│   ├── dashboard/
│   ├── customers/
│   ├── products/
│   ├── invoices/
│   └── payments/
│
├── services/
│   ├── database_service.dart
│   ├── firebase_service.dart
│   ├── email_service.dart
│   └── invoice_service.dart
│
├── widgets/
│
└── main.dart
```

---

## 🛠️ Technologies Used

| Technology             | Purpose                           |
| ---------------------- | --------------------------------- |
| **Flutter**            | Cross-platform UI development     |
| **Dart**               | Application programming language  |
| **Firebase**           | Backend and cloud synchronization |
| **Cloud Firestore**    | Cloud database                    |
| **SQLite / sqflite**   | Local/offline database            |
| **Provider**           | State management                  |
| **PDF Package**        | Invoice PDF generation            |
| **Google Apps Script** | Automated email workflow          |
| **Git / GitHub**       | Version control                   |

---

## 🔄 Data Synchronization

The application uses a hybrid local + cloud architecture:

```text
                 ┌──────────────────┐
                 │   Flutter App    │
                 └────────┬─────────┘
                          │
                 ┌────────▼─────────┐
                 │   Local SQLite   │
                 │    Database      │
                 └────────┬─────────┘
                          │
                    Sync Process
                          │
                 ┌────────▼─────────┐
                 │     Firebase     │
                 │   Cloud Firestore│
                 └──────────────────┘
```

The local database allows the application to operate offline, while Firebase provides cloud synchronization and centralized data storage.

---

## 📧 Invoice Email Workflow

```text
Create Invoice
      │
      ▼
Generate PDF
      │
      ▼
Store Invoice
      │
      ▼
Trigger Email Workflow
      │
      ▼
Attach PDF Invoice
      │
      ▼
Send Email to Customer
```

---

## 🖥️ Application Screens

🔐 Login

Secure login interface for accessing the billing application.

📊 Dashboard

Provides an overview of invoices, customers, payments, products, and revenue.

👥 Customers

Manage customer information and billing history.

📦 Products

Manage products and pricing information.

🧾 Invoice

Create, generate, print, and manage customer invoices.

💳 Payments

Track payment status and maintain payment records
## 📸 Screenshots

> Screenshots can be added here to demonstrate the application UI.

### Login

<img width="940" height="484" alt="image" src="https://github.com/user-attachments/assets/994f81ac-cc52-41d9-b0c2-dae3c40477af" />

### Dashboard

<img width="940" height="555" alt="image" src="https://github.com/user-attachments/assets/af973f82-0cc9-476c-859a-4e94c1a70252" />


### Customers

<img width="815" height="318" alt="image" src="https://github.com/user-attachments/assets/7e5d740f-8a8a-4c2d-b410-ab41be67764d" />


### Products

<img width="821" height="323" alt="image" src="https://github.com/user-attachments/assets/6ece7b34-10e8-4942-8881-872db3078811" />


### Invoice
<img width="940" height="529" alt="image" src="https://github.com/user-attachments/assets/1232c4a9-0322-40f3-a3a6-999fdfd58584" />

<img width="959" height="521" alt="image" src="https://github.com/user-attachments/assets/afc95bbd-8e70-4e2a-b941-a07447da3db5" />


### EMAIL
<img width="831" height="346" alt="image" src="https://github.com/user-attachments/assets/f69aec78-2aeb-4648-b4f4-ea252407e1e9" />



---

## ⚙️ Getting Started

### Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Git
* Windows Desktop development environment
* Firebase project

### Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/flutter-billing-app.git
```

### Navigate to the Project

```bash
cd flutter-billing-app
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run -d windows
```

---

## 🔐 Environment & Security

Sensitive configuration files and credentials are **not included in this repository**.

The following files should remain private:

```text
.env
firebase-adminsdk.json
service-account.json
API credentials
Email credentials
Production configuration
```

Before running the application, configure the required Firebase and email credentials according to your environment.

---

## 📌 Project Highlights

* Developed a complete **Flutter Desktop Billing Application**
* Implemented **Firebase integration and cloud synchronization**
* Implemented **offline-first local database storage**
* Developed **PDF invoice generation**
* Implemented **automated email delivery with PDF attachments**
* Implemented **customer, product, invoice, and payment management**
* Implemented **state management using Provider**
* Designed a modular and maintainable Flutter application architecture
* Integrated local and cloud data synchronization

---

## 🎯 Learning & Technical Focus

This project demonstrates practical experience in:

* Flutter Desktop Development
* Dart Programming
* State Management
* Firebase Integration
* Cloud Firestore
* Local Database Management
* Offline-first Application Design
* REST/API Integration
* PDF Generation
* Email Automation
* Authentication
* CRUD Operations
* Application Architecture
* Debugging and Error Handling
* Git and Version Control

---

## 🔮 Future Enhancements

* Role-based access control
* Advanced sales analytics
* Inventory management
* Automated payment reconciliation
* Advanced reporting
* Multi-user support
* Improved cloud synchronization conflict handling
* Automated database backup

---

## 👨‍💻 Author

**PRABHAKARAN MANIKANDAN**

Flutter Developer | Dart | Firebase | Desktop Applications

---

## 📄 License

This project is intended for educational, portfolio, and demonstration purposes.
