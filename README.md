# dognet

DogNet is a Flutter-based mobile application that identifies the breed of a dog from an image using a TensorFlow Lite model. The application performs on-device inference, enabling fast and offline predictions.

## Project Overview

This project demonstrates the integration of a machine learning model into a Flutter application. Users can upload or capture an image of a dog, and the app predicts the most likely dog breed using a pre-trained deep learning model converted to TensorFlow Lite.

## Tech Stack

- Flutter (Dart)
- TensorFlow Lite
- tflite_flutter
- Android Studio

## How It Works

1. The user selects or captures an image of a dog  
2. The image is preprocessed to match the model input requirements  
3. The TensorFlow Lite model runs inference on the device  
4. The predicted dog breed is displayed to the user  

## Getting Started

This project follows the standard Flutter project structure.

### Prerequisites

- Flutter SDK
- Android Studio or VS Code
- Android emulator or physical device

### Running the Project

```bash
flutter pub get
flutter run
