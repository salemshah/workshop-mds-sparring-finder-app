# 🥊 Sparring Finder App

Application Flutter multiplateforme pour trouver des partenaires de sparring, planifier des sessions, gérer son profil et discuter via une messagerie intégrée.

---

## 🚀 Démarrage rapide

### 🔧 Prérequis

- **Flutter SDK** (≥ 3.x recommandé)
- **Android Studio / Xcode** (selon plateforme cible)
- **Backend compatible** (ex. [workshop-mds-sparring-finder](https://github.com/ton-projet/workshop-mds-sparring-finder))

---

### ⚙️ Installation

```bash
git clone https://github.com/ton-projet/workshop-mds-sparring-finder-app.git
cd workshop-mds-sparring-finder-app
flutter pub get
```

---

### ▶️ Lancement

```bash
flutter run
```

- **Pour iOS** : ouvrir dans Xcode, choisir un simulateur ou appareil réel, puis lancer.

---

## 🧠 Fonctionnement général

| Composant                  | Description                                 |
|----------------------------|---------------------------------------------|
| `ApiService`               | Communication avec l’API backend            |
| `flutter_bloc`             | Gestion d’état                              |
| `Provider`                 | Injection de dépendances                    |
| `AppRoutes`                | Navigation centralisée                      |
| `Firebase Cloud Messaging` | Notifications push                          |
| `flutter_secure_storage`   | Stockage sécurisé des tokens                |
| `flutter_screenutil`, `google_fonts` | UI responsive + typographies personnalisées |

---

## 🗂️ Structure du projet

```text
lib/
├── main.dart                  # Point d’entrée
└── src/
    ├── blocs/                 # Gestion d’état (BLoC / Cubit)
    ├── config/                # Routes, constantes, providers
    ├── models/                # Modèles de données
    ├── repositories/          # Accès aux données via API
    ├── services/              # Services (API, notifications, stockage sécurisé)
    ├── ui/
    │   ├── screens/           # Écrans principaux
    │   └── widgets/           # Composants réutilisables
    └── utils/                 # Fonctions utilitaires
```

---

## 🧩 Services principaux

| Service                | Rôle                                                      |
|------------------------|-----------------------------------------------------------|
| `ApiService`           | Requêtes HTTP vers l’API backend                          |
| `NotificationService`  | Gestion des notifications push                            |
| `SecureStorageHelper`  | Stockage sécurisé des tokens et préférences               |
| `Repositories`         | Couche d’accès aux données (User, Profile, Sparring, Availability…) |

---

## 🧭 Navigation (`AppRoutes`)

| Route                     | Description                        |
|---------------------------|------------------------------------|
| `/login`                  | Connexion                          |
| `/register`               | Inscription                        |
| `/verify-email`           | Vérification email                 |
| `/forgot-password`        | Mot de passe oublié                |
| `/reset-password`         | Réinitialisation mot de passe      |
| `/home-screen`            | Découverte des athlètes            |
| `/profile`                | Profil utilisateur                 |
| `/availability-form`      | Déclaration de disponibilités      |
| `/sparring-screen`        | Sessions de sparring               |
| `/chat-list-screen`       | Liste des conversations            |
| `/chat-screen`            | Discussion avec un utilisateur     |
| `/onboarding`             | Onboarding utilisateur             |
| `/settings`               | Paramètres                         |
| `/privacy-policy-screen`  | Politique de confidentialité       |

---

## 📦 Librairies principales

| Librairie                                 | Utilisation                           |
|-------------------------------------------|---------------------------------------|
| `flutter_bloc`, `provider`                | Gestion d’état, DI                    |
| `http`                                   | Requêtes HTTP                         |
| `firebase_core`, `firebase_messaging`     | Notifications push                    |
| `flutter_secure_storage`                  | Stockage local sécurisé               |
| `google_fonts`, `lottie`                  | UI / animations                       |
| `syncfusion_flutter_calendar`             | UI avancée (planning, sessions)       |
| `share_plus`, `url_launcher`              | Partage & ouverture de liens externes |
| `image_picker`, `image_cropper`           | Gestion des images de profil          |

---

## 🔍 Fonctionnalités

- 🔐 Authentification complète (email, reset mot de passe, vérification)
- 👤 Gestion du profil utilisateur
- 📅 Déclaration de disponibilités via calendrier
- 🔎 Recherche de partenaires avec filtres
- 📬 Sessions de sparring (création, confirmation, annulation)
- 💬 Messagerie instantanée
- 📲 Notifications push en temps réel
- 🎯 Onboarding interactif
- ⚙️ Paramètres avancés (compte, préférences, politique de confidentialité)

---

## 🧱 Architecture

| Couches                | Description                                      |
|------------------------|--------------------------------------------------|
| UI (screens/widgets)   | Composants d’interface utilisateur               |
| BLoC / Cubits          | Gestion des états complexes                      |
| Repositories           | Couche d’abstraction des données                 |
| Services               | Gestion des API, stockage sécurisé, Firebase…    |
| Models                 | Modèles métier (User, Sparring, Message, etc.)   |

---

## ⚙️ Personnalisation

| Élément                | Emplacement                           |
|------------------------|---------------------------------------|
| URL de l’API           | `lib/src/config/app_constants.dart`   |
| Thèmes / Couleurs      | `lib/src/ui/theme/`                   |
| Assets (images, lotties)| `assets/` + déclaration dans `pubspec.yaml` |

---

## 📚 Documentation supplémentaire

- 🔗 Backend API : [workshop-mds-sparring-finder (backend)](https://github.com/ton-projet/workshop-mds-sparring-finder)

---

## 👥 Auteurs

- 🧑‍💻 **SHAH Salem** – Salemshahdev@gmail.com
- 🧑‍💻 **CAMARA Bafodé** – bafodecamara@gmail.com
- 🧑‍💻 **MIBE Gerard** – mibekeumeni@gmail.com
