import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/widgets/comment_widget.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';

class BlogPostDetailGuest extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;
  final int commentCount;
  final List<Map<String, String>> comments;

  BlogPostDetailGuest({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.commentCount,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Hình ảnh bài viết
              Image.network(
                imageUrl,
                height: 800,
                width: 2000,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.0),
              // Tiêu đề bài viết
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              // Nội dung bài viết
              Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              // Số lượng bình luận
              Text(
                '$commentCount comments',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              // Các mẹo tăng cường miễn dịch (hoặc nội dung khác)
              Text(
                'Tips for Boosting Your Immunity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              // Hiển thị danh sách bình luận
              Text(
                'Comments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         decoration: InputDecoration(
              //           labelText: 'Write a comment',
              //           border: OutlineInputBorder(),
              //           filled: true,
              //           fillColor: Colors.white,
              //         ),
              //         onSubmitted: (String value) {
              //           // Xử lý khi người dùng gửi bình luận
              //           // if (value.isNotEmpty) {
              //           //   addComment(value);
              //           // }
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 8.0), // Khoảng cách giữa TextField và nút
              //     CustomElevatedButton(
              //       onPressed: () {
              //         // Xử lý khi người dùng nhấn nút gửi
              //         // Bạn có thể thêm logic để lưu bình luận ở đây
              //       },
              //       text: 'Send',
              //     ),
              //   ],
              // ),
              SizedBox(height: 8.0),
              // Sử dụng ListView để hiển thị bình luận
              Container(
                height: 200, // Đặt chiều cao cho phần bình luận
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Comment(
                      userName: comments[index]['userName']!,
                      content: comments[index]['content']!,
                    );
                  },
                ),
              ),
              // Thêm TextField để viết bình luận

              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
