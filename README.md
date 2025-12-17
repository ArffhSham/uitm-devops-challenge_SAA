# 👥 Group Introduction

**Group Name:** ASA

**Member:** 
1. Ariffah binti Shamsuddin
2. Syaza Munira binti Mohd Subri
3. Nurul Aqila binti Yusni 

Role & Responsibility  
--

| Role | Responsibility |
| :---: | :---: |
| Offensive Security Engineer | Conducts Penetration Testing and Tries to find vulnerabilities in app.  |
| The Frontend Specialist | Create the interface and layout and Write the code that runs in the browser. |
| Defensive Security Engineer | Sets up Authentication (Login systems, OAuth, MFA) and Handles Encryption |


---

# How To Use

## 1. 🔒 Login Process
   * The user enter the email and password
   * Click submit and the user will enter the phone number to get OTP number
   * Enter the OTP number in the OTP page
   * The system will verify the OTP number
   * The system generate JWT token, this token will recognise Tenant, Owner, or Admin
   * The user will be send to dashbord 


## 2. 🏠 For Tenants: Finding Your Next Home
  * The tenant experience is built for ease of discovery and secure legal processing.
  * **Search Properties:** Use the search bar to filter properties by Location, Price, and Property Type (e.g., Apartment, Studio).
  * **Explore Featured Listings:** Browse the "Featured Properties" section on your dashboard to see verified homes.
  * **Rental Request:** Once you find a property, click the Rental Request Agreement button.
  * **Secure Signing:** Review the digital agreement and provide your electronic signature. This document is encrypted and stored securely for your protection.


## 3. 🔑 For Owners: Managing Your Assets
  * Owners have a streamlined interface focused on property visibility and listing management.
  * **View Listings:** Monitor your "Featured Properties" to see how your listings are positioned in the marketplace.
  * **Upload New Property:** Click the "Add Property" button.
  * Enter details including location, price, and high-quality photos.
  * Submit for verification. Once approved, your property will be visible to potential tenants.


## 4.🛡️ For Admins: Oversight & Security
  * Admins maintain the integrity of the platform through constant monitoring.
  * **Feature Oversight:** View all featured properties to ensure they meet platform quality standards.
  * **Anomaly Detection:** Access the Anomaly Dashboard to identify any suspicious behavior, such as price manipulation or fraudulent listing patterns.
  * **Activity Logs:** Review the Activity Log to track every action taken on the platform. This provides a full audit trail for security and dispute resolution.


### Security Overview at a Glance

| Feature | Tenant | Owner | Admin |
| :---: | :---: | :---: | :---: |
|Search & Filter|✅|❌|❌|
|Sign Agreements|✅|❌|❌|
|Upload Property|❌|✅|❌|
|View Featured|✅|✅|✅|
|Check Anomalies|❌|❌|✅|
|Activity Logs|❌|❌|✅|

---

# Module 1: Secure Login & MFA

## Overview
This module establishes the first line of defense by implementing **MFA/OTP-based** 
logins to ensure that only authorized individuals can access the system. 
It utilizes **role-based access control** to strictly define the boundaries between tenant, owner, and admin 
functionalities, aligning with **OWASP M1–M3** standards for robust authentication and authorization.

### Authentication & MFA Flow
* **Login with MFA:** email/password → MFA_REQUIRED → user submits 6-digit OTP → JWT issued.
* **MFA setup:** authenticated user requests setup → OTP secret +  returned → user confirms with OTP → MFA enabled.

### Testing MFA Flow
1. Login with valid credentials.
2. Go to MFA Setup page → Enable MFA.
3. Give phone number to get OTP .
4. Confirm with 6-digit OTP (MFA enabled).

---

# Module 2: Secure API Gateway 

## Overview
The Secure API Gateway manages all data transitions between the user interface and the server using
**HTTPS and JWT tokens** to maintain secure communication. To prevent cyberattacks and unauthorized data
harvesting, the module incorporates **rate-limiting and access validation**, ensuring the system adheres
to **OWASP M5–M6** security protocols.

### Secure API Gateway Flow
    1. Client sends request to /api/*
    2. HTTPS enforced in production (redirect HTTP → HTTPS)
    3. Rate limiting applied per IP
    4. Security headers added (Helmet)
    5. JWT token validated (protected routes)
    6. Role and ownership checks performed
    7. Request forwarded to route/controller → database → response returned


### 🧱 Architecture Components
* Backend
  * Express.js
  * express-rate-limit (rate limiting)
  * JWT (authentication)
  * Prisma + PostgreSQL (data layer)

* Frontend (Consumption)
  * Next.js
  * Sends JWT in request header
  
---

# Module 3: Digital Agreement (Mobile) 

## Overview
Focused on **data integrity and workflow validation**, this module adapts the existing rentverse framework 
to handle legally binding documents on mobile devices. It introduces **secure signature validation** and 
specific access permissions, ensuring that once a tenant signs a rental request, the document remains 
tamper-proof and accessible only to the relevant parties.

It extends the RentVerse platform from property discovery and booking into contract execution, ensuring:

 * Trust between landlord and tenant
 * Legal defensibility of agreements
 * Protection against document tampering or fraud

Once a tenant signs a rental request or agreement, the document becomes cryptographically locked, traceable, and auditable.


### Step-by-Step Agreement Lifecycle

**1. Agreement Generation**
 * Rental terms are compiled into a structured document (PDF / JSON-backed PDF).
 * Metadata is embedded:
     * Property ID
     * Tenant ID
     * Landlord ID
     * Timestamp
     * Agreement version

**2. Pre-Signature State**
 * Document is editable only by authorized parties.
 * A pre-signature hash is generated.
 * Version tagged as DRAFT.

**3. Mobile Signature Capture**
 * Tenant signs using:
     * Touch signature
     * Stylus

**4. Signature Validation & Lock**
 * Signature is cryptographically bound to the document hash.
 * Document state transitions to SIGNED.

**5. Post-Signature Enforcement**
 * Any modification invalidates the signature.
 * A new version must be generated for changes.

### 🔐 Security & Integrity

* Document hashing & checksum verification
* Tamper-evident sealing after signature
* Immutable versioning (pre- and post-signature)
* Signature invalidation on modification
* Encrypted storage (at rest & in transit)

### Access Control & Permissions
#### Role-Based Access
|Role |	Permissions |
|:---:|:---:|
|Tenant	| View & sign own agreements |
|Landlord	| View agreements for owned properties |
|Admin	| Audit-only access (no edits) |

 * No role can alter a signed document.
 * Access is logged for auditability.

---

# Module 4: Smart Notification & Alert System 

## Overview
Designed for **incident detection**, this module acts as a continuous monitoring tool that logs all user 
activities in real-time. It is programmed to identify and **alert admins to suspicious login patterns**, 
allowing for immediate intervention during potential security breaches or unauthorized access attempts.


### 🧠 Security Events Tracked

The system will record the following activity:

* Login Success
* Login Failed
* Suspicious Login
* MFA/OTP authorization

### 🌍 Contextual Risk Signals

* New or unrecognized device
* IP address changes mid-session
* Use of VPN, proxy, or TOR
* Access outside normal business hours

---

# Module 5: Activity Log Dashboard 

## Overview
This high-level administrative tool provides **threat visualization and accountability** by compiling detailed
records of system interactions. It specifically tracks **failed login attempts and critical actions**, giving 
administrators the necessary data to audit the system's health and investigate potential security anomalies.

### 📝 The Activity Log Dashboard displays all records, including:

* All login activities
* Suspicious actions
* anomaly security :
  - abnormal login time detection
  - multiple time
  - suspicious location detection
* Any security critical actions

### 👤 User & Identity Context

* User role at time of action
* Account status login and failed
* Service account & API token usage
* Delegated or impersonated actions

---

## 🚀 Installation & Setup

### Prerequisites
* **Flutter SDK:** v3.0.0 or higher
* **Android Studio / VS Code**
* **PostgresSQL** Database
* **Emulator/Device:** Android API 31+ (recommended)

### Language & Package Managers
 * Scrapy → collects raw data
 * Pandas → cleans & analyzes it
 * Scikit-learn → builds predictive models
 * Flask → exposes results via an API
 * Poetry → manages Python dependencies
 * pnpm / Bun / npm → manage JS apps
 * Husky → enforces quality rul8
 * Flutter → delivers mobile apps


### Steps
1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/your-username/uitm-devops-challenge_SAA.git](https://github.com/your-username/uitm-devops-challenge_SAA.git)
    ```
2.  **Install Dependencies:**
    ```bash
    cd rentverse_mobile
    flutter pub get
    bun install 
    
    # Or using npm
    npm install
    ```
3.  **Run the App:**
    ```bash
    flutter run
    ```
4.  **Run the Database:**
    ```bash
    bun run dev
    ```
---

## 🛠️ Project Structure
```text
rentverse_mobile/
├── android/
├── build/
├── ios/
├── lib/
│   ├── core/
│   ├── enums/
│   │   └── user_role.dart
│   ├── features/
│   │   ├── agreement/
│   │   │   ├── data/
│   │   │   └── ui/
│   │   ├── auth/
│   │   ├── properties/
│   │   │   ├── data/
│   │   │   └── ui/
│   │   ├── property/
│   │   │   └── ui/
│   │   │       └── listing_review_screen.dart
│   │   └── security/
│   │       ├── data/
│   │       │   ├── anomaly_log_model.dart
│   │       │   └── security_alert_service.dart
│   │       ├── logic/
│   │       │   └── anomaly_detector.dart
│   │       ├── models/
│   │       │   ├── activity_log_model.dart
│   │       │   └── activity_log.dart
│   │       ├── services/
│   │       └── ui/
│   ├── models/
│   │   ├── activity.dart
│   │   ├── agreement_details.dart
│   │   ├── property.dart
│   │   └── user.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── html_renderer_service.dart
│   │   └── user_provider.dart
│   ├── shared/
│   │   └── widgets/
│   │       ├── property_card.dart
│   │       └── secure_button.dart
│   ├── home_page.dart
│   └── main.dart
├── linux/
└── macos/
```


* **First Modularization:** The project uses a Feature-Driven Architecture (inside the features folder).
Each major functionality—like security, agreement, or properties—is self-contained with its own data, ui, and logic layers,
making the code easier to maintain and scale without affecting other parts of the app.

* **Layered Responsibility:** It maintains a clear separation between Global and Local resources. General data structures and shared
UI components are kept in the root models and shared/widgets folders, while specific logic (like the anomaly_detector.dart found
in the security feature) is kept close to where it is actually used.
