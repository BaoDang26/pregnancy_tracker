// import 'package:bmi_tracker_mb_advisor/screens/blog/model/blog_model.dart';
// import 'package:bmi_tracker_mb_advisor/theme/custom_text_style.dart';
// import 'package:bmi_tracker_mb_advisor/theme/theme_helper.dart';
// import 'package:bmi_tracker_mb_advisor/util/size_utils.dart';
// import 'package:bmi_tracker_mb_advisor/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import 'custom_image_view.dart';

class CustomBlogCard extends StatefulWidget {
  final String photoUrl;
  final String title;
  // final BlogModel blog;
  final String? content1;
  final String? content2;
  final String? content3;
  final String? content4;
  final int commentCount;
  final VoidCallback onTitleTap;

  const CustomBlogCard(
      {
      // required this.blog,
      required this.photoUrl,
      required this.title,
      this.content1,
      this.content2,
      this.content3,
      this.content4,
      required this.commentCount,
      required this.onTitleTap,
      Key? key})
      : super(key: key);

  @override
  _CustomBlogCardState createState() => _CustomBlogCardState();
}

class _CustomBlogCardState extends State<CustomBlogCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding:
            // EdgeInsets.only(bottom: 5.v, top: 10.v, left: 10.v, right: 10.v),
            const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomImageView(
              // imagePath: '${blog.blogPhoto}',
              imagePath:
                  'https://res.cloudinary.com/dlipvbdwi/image/upload/v1696896650/cld-sample.jpg',
              height: 200.v,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10.0),
            //   child: Image.network(
            //     '${blog.blogPhoto}',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            SizedBox(height: 5.v),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: GestureDetector(
                  onTap: widget.onTitleTap,
                  child: Text(
                    // '${blog.blogName}',
                    'Blog Title',
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      decoration: _isHovering ? TextDecoration.underline : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Text(
              '${widget.commentCount} comments',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            // if (content1 != null) ...[
            // Padding(
            //   padding: EdgeInsets.only(bottom: 5.v),
            //   child: Text(
            //     'Content 1',
            //     style: theme.textTheme.bodyMedium,
            //   ),
            // ),
            // SizedBox(height: 5),
            // ],
            // if (content2 != null) ...[
            //   Padding(
            //     padding: EdgeInsets.only(bottom: 5.v),
            //     child: Text(
            //       content2!,
            //       style: theme.textTheme.bodyMedium,
            //     ),
            //   ),
            // ],
            // if (content3 != null) ...[
            //   Padding(
            //     padding: EdgeInsets.only(bottom: 5.v),
            //     child: Text(
            //       content3!,
            //       style: theme.textTheme.bodyMedium,
            //     ),
            //   ),
            // ],
            // if (content4 != null) ...[
            //   Padding(
            //     padding: EdgeInsets.only(bottom: 5.v),
            //     child: Text(
            //       content4!,
            //       style: theme.textTheme.bodyMedium,
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
