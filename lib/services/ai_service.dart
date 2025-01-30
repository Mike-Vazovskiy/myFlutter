import '../models/message.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // Заглушка для «ответа» от AI
  Future<Message> getAIResponse(String userMessage) async {
    // Здесь в будущем вы подключите реальную офлайн AI-модель
    await Future.delayed(const Duration(seconds: 1)); // имитация задержки
    return Message(
      text: "Это заглушка ответа на: $userMessage",
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
