// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/chat.dart';
import 'models/message.dart';
import 'repositories/chat_repository.dart';
import 'screens/onboarding_screen.dart'; 
import 'services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(ChatAdapter());
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Chat>('chatsBox');
  await ChatRepository().init();
  await AIService.loadModel();
  
  runApp(const OfflineAiChatApp());
}

class OfflineAiChatApp extends StatelessWidget {
  const OfflineAiChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline AI Chat',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        appBarTheme: const AppBarTheme(color: Color(0xFF2196f3)),
      ),
      // home: const ChatListScreen(), //  <-- Было так
      home: const OnboardingScreen(),    //  <-- Показываем Onboarding
    );
  }
}
