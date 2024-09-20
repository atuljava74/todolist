# Todo List

A Flutter-based Todo List App , integrated with firestore database. The app is built using the Provider (MVVM) pattern to separate business logic from the UI, ensuring a clean and maintainable codebase.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- A code editor, such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- A connected device or emulator for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ecommerce_portal.git
   cd ecommerce_portal

2. Install Dependencies
   ```bash
   flutter pub get

3. Run the app
   ```bash
   flutter run
   
### Architecture
The app follows a Layered Architecture using the MVVM Pattern:

1. Presentation Layer: UI components managed by Flutter widgets (screens/  folders).
2. Business Logic Layer: ViewModel classes handle business logic and state management (Provider).
3. Data Layer: Models and Database Service class is Model and Service folders.
4. This architecture ensures separation of concerns, making the app more scalable and easier to maintain.

### Features

1. User can create task.
2. Mark it completed.
3. Delete task.
4. Check task date wise.






