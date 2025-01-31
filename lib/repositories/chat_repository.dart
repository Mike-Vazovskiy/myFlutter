import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/chat.dart';

class ChatRepository {
  static final ChatRepository _instance = ChatRepository._internal();
  factory ChatRepository() => _instance;
  ChatRepository._internal();

  final _uuid = const Uuid();
  late Box<Chat> _chatBox;

  Future<void> init() async {
    _chatBox = Hive.box<Chat>('chatsBox');
  }

  List<Chat> getAllChats() {
    return _chatBox.values.toList();
  }

  Chat? getChatById(String id) {
    try {
      return _chatBox.values.firstWhere((chat) => chat.id == id);
    } catch (_) {
      return null; // если не нашли
    }
  }

  Future<Chat> createChat(String title) async {
    final newChat = Chat(
      id: _uuid.v4(),
      title: title,
      messages: [],
    );
    await _chatBox.add(newChat);
    return newChat;
  }

  Future<void> updateChat(Chat chat) async {
    final index = _chatBox.values.toList().indexWhere((c) => c.id == chat.id);
    if (index != -1) {
      await _chatBox.putAt(index, chat);
    }
  }

  Future<void> deleteChat(String id) async {
    final index = _chatBox.values.toList().indexWhere((c) => c.id == id);
    if (index != -1) {
      await _chatBox.deleteAt(index);
    }
  }
}
