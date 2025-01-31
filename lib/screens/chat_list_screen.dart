// lib/screens/chat_list_screen.dart

import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../repositories/chat_repository.dart';
import '../widgets/create_chat_dialog.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _chatRepository = ChatRepository();
  late List<Chat> _chats;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    _chats = _chatRepository.getAllChats();
    setState(() {});
  }

  Future<void> _createNewChat(String title) async {
    await _chatRepository.createChat(title);
    _loadChats();
  }

  Future<void> _deleteChat(String chatId) async {
    await _chatRepository.deleteChat(chatId);
    _loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои чаты'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ListView.separated(
          itemCount: _chats.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final chat = _chats[index];
            return Card(
              color: const Color(0xFF2196f3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDetailScreen(chatId: chat.id),
                    ),
                  );
                  _loadChats();
                },
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  leading: const Icon(Icons.chat_bubble_outline, color: Colors.white70),
                  title: Text(
                    chat.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '${chat.messages.length} сообщений',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white60),
                    onPressed: () => _deleteChat(chat.id),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () async {
          // Открываем диалог
          final newTitle = await showDialog<String>(
            context: context,
            builder: (_) => const CreateChatDialog(),
          );
          
          // Если пользователь ввёл название
          if (newTitle != null && newTitle.isNotEmpty) {
            final newChat = await _chatRepository.createChat(newTitle);
            
            // Обновляем локально список чатов (если нужно)
            _loadChats(); 
            
            // И сразу переходим на экран нового чата
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(chatId: newChat.id),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
