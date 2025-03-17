import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String userName;
  final String content;

  Comment({
    required this.userName,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền của bình luận
        border: Border.all(color: Colors.grey.shade300), // Viền màu xám nhạt
        borderRadius: BorderRadius.circular(8.0), // Bo góc
        boxShadow: [
          const BoxShadow(
            color: Colors.black26, // Màu bóng
            blurRadius: 4.0, // Độ mờ của bóng
            offset: const Offset(2, 2), // Vị trí bóng
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0), // Khoảng cách bên trong
      margin:
          const EdgeInsets.symmetric(vertical: 4.0), // Khoảng cách bên ngoài
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4.0),
          Text(
            content,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const Divider(), // Thêm đường kẻ phân cách giữa các bình luận
        ],
      ),
    );
  }
}
