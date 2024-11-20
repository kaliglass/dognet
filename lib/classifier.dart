import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

class Classifier {
  late Interpreter interpreter;
  final int inputSize = 224;

  // Separate initialization method
  Future<void> init() async {
    interpreter = await Interpreter.fromAsset('assets/model.tflite');
  }

  Future<List<dynamic>> classifyImage(File image) async {
    // Ensure the interpreter is initialized
    var tensorImage = await preprocessImage(image);

    // Prepare output buffer
    var probabilityBuffer = List.filled(120, 0.0).reshape([1, 120]);

    // Run inference
    interpreter.run(tensorImage, probabilityBuffer);

    // Load labels
    List<String> labels = await loadLabels('assets/labels.txt');

    // Find the highest probability and corresponding label
    double highestProb = 0;
    String dogBreed = "";
    for (int i = 0; i < probabilityBuffer[0].length; i++) {
      double probability = probabilityBuffer[0][i];
      if (probability > highestProb) {
        highestProb = probability;
        dogBreed = labels[i];
      }
    }

    var outputProb = (highestProb * 100).toStringAsFixed(1);
    return [dogBreed, outputProb];
  }

  Future<Uint8List> preprocessImage(File image) async {
    img.Image? originalImage = img.decodeImage(await image.readAsBytes());

    img.Image resizedImage = img.copyResize(originalImage!, width: inputSize, height: inputSize);

    Float32List input = Float32List(inputSize * inputSize * 3);
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        int pixel = resizedImage.getPixel(x, y);
        input[y * inputSize * 3 + x * 3 + 0] = (img.getRed(pixel) / 255.0);
        input[y * inputSize * 3 + x * 3 + 1] = (img.getGreen(pixel) / 255.0);
        input[y * inputSize * 3 + x * 3 + 2] = (img.getBlue(pixel) / 255.0);
      }
    }

    return input.buffer.asUint8List();
  }

  Future<List<String>> loadLabels(String path) async {
    final labelData = await rootBundle.loadString(path);
    return labelData.split('\n');
  }
}
