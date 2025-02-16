import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
// import '../../widgets/blog_card_widget.dart';
import '../../widgets/custom_card_blog_widget.dart';

class BlogPostGuest extends StatelessWidget {
  const BlogPostGuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            const Text(
              'BLOG POST',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The blog post is a collection of articles that are related to the pregnancy journey.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // Grid of blog posts
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15.v),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // controller.goToBlogDetail(index);
                              },
                              child: AspectRatio(
                                aspectRatio:
                                    1.0, // Adjust this ratio to fit the Container
                                child: Stack(
                                  children: [
                                    CustomBlogCard(
                                      photoUrl:
                                          'https://res.cloudinary.com/dlipvbdwi/image/upload/v1696896650/cld-sample.jpg',
                                      title: 'Blog title',
                                      // blog: controller.blogList[index],
                                      // photoUrl: controller.blogModel.value.blogPhoto,
                                      // title: controller.blogModel.value.blogName,
                                      onTitleTap: () {
                                        // Get.to(BlogDetailScreen());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                            // return Obx(
                            //   () =>
                            // );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
