# Mini E-Commerce App

A modern, full-featured Flutter e-commerce app built with **Clean Architecture**, **Firebase**, and **Stripe**. This project demonstrates authentication, product browsing, cart management, payments, and more — with a focus on **scalability**, **maintainability**, and **best practices**.

---

## 🚀 Features

### ✅ Core Features
- **User Authentication**
    - Firebase Authentication
    - Google Sign-In
    - Email & Password authentication
- **Product Listing**
    - Products fetched from Firestore
    - Cached images using `cached_network_image`
- **Product Details**
    - Dedicated product details page
    - Add products to cart with quantity selection
- **Cart Management**
    - Add, update, and remove products
    - Persistent cart state
- **User Profile**
    - View & edit profile info
    - Data stored in Firestore
- **Push Notifications**
    - Firebase Cloud Messaging
    - Local notifications for foreground messages
- **Payments**
    - Stripe integration
    - Secure checkout & payment flow

### 🎁 Bonus Features
- Product search with instant filtering
- Localization support with intl (implemented but JSON dictionary for strings not yet provided)
- Google Maps integration (user location + nearby stores)
- Profile picture picker & cropper
- In-app reviews with `in_app_review`

---

## 🏗️ Architecture

The app follows **Clean Architecture** principles for scalability and testability:

Presentation Layer → Flutter UI + Provider for state management
Domain Layer → Entities & Use Cases (pure business logic)
Data Layer → Firebase/Stripe repositories & datasources
Core → Utilities, error handling (Result class), dependency injection


**Why this design?**
- **Separation of concerns** → easy to maintain & test
- **Reusability** → backend can be replaced without breaking UI
- **Clear flow** → Data → Domain → UI

---

## 🛠️ Tech Stack
- Flutter (latest stable)
- Firebase
    - Authentication
    - Firestore
    - Cloud Messaging
- Stripe (payments)
- Provider (state management)
- Flutter Local Notifications
- Intl (localization)
- Image Picker & Cropper

---

## 📸 Screenshots

<div align="center">

<img src="https://firebasestorage.googleapis.com/v0/b/fluuter-learning.appspot.com/o/app%2F1.jpg?alt=media&token=86a1cd9f-449d-4c6d-8adf-4cd666a6ab73" width="300px" alt="Home Screen">  
*Home Screen*

<img src="https://firebasestorage.googleapis.com/v0/b/fluuter-learning.appspot.com/o/app%2F2.jpg?alt=media&token=fb47a744-a25f-4a25-a0be-46ceabc24878" width="300px" alt="Product Details">  
*Product Details*

<img src="https://firebasestorage.googleapis.com/v0/b/fluuter-learning.appspot.com/o/app%2F3.jpg?alt=media&token=c8271ded-cd4a-48fb-a53c-fbe4342fb661" width="300px" alt="Cart">  
*Cart*

<img src="https://firebasestorage.googleapis.com/v0/b/fluuter-learning.appspot.com/o/app%2F9.jpg?alt=media&token=9250f0e1-c679-4ceb-b217-ef7e70532830" width="300px" alt="User Profile">  
*User Profile*

<img src="https://firebasestorage.googleapis.com/v0/b/fluuter-learning.appspot.com/o/app%2F5.jpg?alt=media&token=376ca7f5-d5fc-4f52-bc9f-fdc6e318698e" width="300px" alt="Register">  
*Register*

</div>
## 🎥 Demo Video

Check out the demo of the app on YouTube:  
[![Mini E-Commerce App Demo](https://firebasestorage.googleapis.com/v0/b/fluuter-learning.appspot.com/o/app%2F22.jpg?alt=media&token=9f13ad6b-090b-4212-80c5-c7a174159e2e)](https://www.youtube.com/shorts/qB81oAx4Mlg)

## ⚡ Getting Started

1. **Clone the repo**
```bash
git clone https://github.com/MoSallah21/mini-ecommerce-app.git
cd mini-ecommerce-app```
```
2. **Install dependencies**
```bash
flutter pub get
```
3. **Firebase setup**

- Create a Firebase project
- Enable Authentication (Email/Google)
- Enable Firestore Database
- Enable Cloud Messaging
- Download google-services.json (Android) and GoogleService-Info.plist (iOS) into android/app and ios/Runner
4. **Stripe setup**
- Create a Stripe account
- Get your Publishable Key (Flutter) and Secret Key (backend if used)
- Set the key in your app:
  Stripe.publishableKey = "pk_test_...";
4. **Run the app**
   flutter run
   📂 Project Structure
   lib/
   ├── core/                   # Helpers, cache, error handling
   ├── features/
   │   ├── localization/       # Localization
   │   ├── auth/               # Authentication
   │   ├── products/           # Product listing, details, cart
   │   ├── profile/            # User profile
   ├── injection_container.dart # Dependency Injection
   └── main.dart               # App entry point

    🧪 Testing
    Run unit & widget tests:
    ```bash
    flutter test
    ```
    📖 Documentation
    -All classes/functions include inline documentation
    -Clean commit history for easy project walkthrough
    -Follows best practices for state management & architecture
