// chat_bot.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:onnxruntime_flutter/onnxruntime_flutter.dart';

class ChatBot {
  late OrtSession _session;

  Future<void> initialize() async {
    // Получаем путь к модели
    final modelPath = await _getModelPath();

    // Проверяем, существует ли файл
    if (!await File(modelPath).exists()) {
      throw Exception("Файл модели не найден по пути: $modelPath");
    }

    // Загружаем модель
    _session = await OrtSession.fromPath(modelPath);
  }

  Future<String> _getModelPath() async {
    // Путь к папке Documents приложения
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/model.onnx'; // Укажите ваше имя файла
  }

  Future<String> generateResponse(String input) async {
    // ... Ваша логика генерации ответа ...
  }
}