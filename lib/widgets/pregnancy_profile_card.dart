import 'package:flutter/material.dart';
import '../util/app_export.dart';

class PregnancyProfileCard extends StatelessWidget {
  final String photoUrl;
  final String title;
  final String? content1;
  final String? content2;
  final String? content3;
  final String? content4;
  final VoidCallback onTitleTap;

  PregnancyProfileCard({
    required this.photoUrl,
    required this.title,
    this.content1,
    this.content2,
    this.content3,
    this.content4,
    required this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 48, 168, 78),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: 3.v, top: 10.v, left: 10.v, right: 10.v),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                photoUrl,
                height: 80.v,
                width: 80.v,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.v),
            Padding(
              padding: EdgeInsets.only(bottom: 5.v),
              child: GestureDetector(
                onTap: onTitleTap,
                child: Text(
                  title,
                  maxLines: 2,
                  softWrap: true,
                  style: CustomTextStyles.titleMediumWhite,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (content1 != null) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: Text(
                  content1!,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              // SizedBox(height: 5),
            ],
            if (content2 != null) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: Text(
                  content2!,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
            if (content3 != null) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: Text(
                  content3!,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
            if (content4 != null) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: Text(
                  content4!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
