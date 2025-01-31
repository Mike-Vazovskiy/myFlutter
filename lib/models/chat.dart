import 'package:hive/hive.dart';
import 'message.dart';

part 'chat.g.dart'; // Файл, который будет сгенерирован Hive для адаптера

@HiveType(typeId: 0)
class Chat {
  @HiveField(0)
  final String id; // уникальный идентификатор чата

  @HiveField(1)
  final String title; // заголовок/название чата

  @HiveField(2)
  final List<Message> messages; // список сообщений в чате

  Chat({
    required this.id,
    required this.title,
    required this.messages,
  });

  Chat copyWith({
    String? id,
    String? title,
    List<Message>? messages,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
    );
  }
}
