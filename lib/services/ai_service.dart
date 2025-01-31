// import '../models/message.dart';
import 'package:flutter/services.dart';

class AIService {
  static const MethodChannel _channel = MethodChannel('my_pytorch_channel');

  static Future<void> loadModel() async {
    await _channel.invokeMethod('loadModel');
  }

  static Future<String> getAIResponse(String userMessage) async {
    // Вызываем runModel
    final result = await _channel.invokeMethod<String>(
      'runModel',
      {'prompt': userMessage},
    );
    return result ?? "Ошибка или null";
  }
}
