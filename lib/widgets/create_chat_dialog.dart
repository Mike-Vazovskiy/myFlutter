import 'package:flutter/material.dart';

class CreateChatDialog extends StatefulWidget {
  const CreateChatDialog({Key? key}) : super(key: key);

  @override
  State<CreateChatDialog> createState() => _CreateChatDialogState();
}

class _CreateChatDialogState extends State<CreateChatDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Светлый фон
      title: const Text(
        'Создать чат',
        style: TextStyle(color: Colors.black), // Чёрный текст заголовка
      ),
      content: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.black), // Чёрный цвет текста
        decoration: const InputDecoration(
          hintText: 'Название чата',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      actions: [
        // Кнопка "Отмена" как TextButton
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2196F3), // Синий текст кнопки
          ),
          child: const Text('Отмена'),
        ),

        // Кнопка "Создать" как ElevatedButton
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _controller.text.trim());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3), // Синий фон
            foregroundColor: Colors.white,             // Белый текст
          ),
          child: const Text('Создать'),
        ),
      ],
    );
  }
}
