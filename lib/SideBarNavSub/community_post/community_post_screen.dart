import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:intl/intl.dart';
// import '../../widgets/blog_card_widget.dart';
import '../../controllers/account_profile_controller.dart';
import '../../controllers/community_post_controller.dart';
import '../../models/community_post_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_card_blog_widget.dart';

class CommunityPostScreen extends GetView<CommunityPostController> {
  const CommunityPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountProfileController>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F0F8), // Soft pink/lavender background
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with beautiful gradient
            Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF5E1EB), // Soft pink
                    Color(0xFFE5D1E8), // Soft lavender
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.forum_rounded,
                        size: 36,
                        color:
                            Color(0xFFAD6E8C), // Mauve/pink for pregnancy theme
                      ),
                      SizedBox(width: 15),
                      Text(
                        'COMMUNITY POSTS',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAD6E8C), // Matching mauve color
                          letterSpacing: 1,
                        ),
                      ),
                      Spacer(),
                      // Get the account controller

                      // Only show Create Post button if user is not a regular user
                      if (!accountController.isRegularUser())
                        _buildActionButton(
                          icon: Icons.add_circle_outline,
                          label: 'Create Post',
                          color: Color(0xFF8E6C88),
                          onTap: () => controller.goToCreateCommunityPost(),
                        ),
                      SizedBox(width: 16),
                      // My Posts button
                      // _buildActionButton(
                      //   icon: Icons.person_outline,
                      //   label: 'My Posts',
                      //   color: Color(0xFF6F9EAF), // Soft blue/teal
                      //   onTap: () => controller.goToCommunityPostOfUser(),
                      // ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'The community post is a place to share your journey, connect with other expecting parents, and find support.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8E6C88).withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Search and filter row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xFF8E6C88),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search community posts...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Recent',
                        icon: Icon(Icons.filter_list, color: Color(0xFF8E6C88)),
                        items: ['Recent', 'Most Comments', 'Oldest']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Grid of community posts
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFAD6E8C)),
                    ),
                  );
                }

                if (controller.activePostList.isEmpty) {
                  return _buildEmptyState();
                }

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(5),
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: controller.activePostList.length,
                    itemBuilder: (context, index) {
                      final post = controller.activePostList[index];
                      return _buildPostCard(context, post, index);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      // Floating action button for quick post creation
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => controller.goToCreateCommunityPost(),
      //   backgroundColor: Color(0xFFAD6E8C),
      //   child: Icon(Icons.add, color: Colors.white),
      //   tooltip: 'Create New Post',
      // ),
    );
  }

  // Helper method to build action buttons
  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build empty state when no posts are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No community posts yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to share your journey',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.goToCreateCommunityPost(),
            icon: Icon(Icons.add),
            label: Text('Create Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8E6C88),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each post card
  Widget _buildPostCard(
      BuildContext context, CommunityPostModel post, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image (if available)
          GestureDetector(
            onTap: () => controller.goToCommunityPostDetail(index),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child:
                  post.attachmentUrl != null && post.attachmentUrl!.isNotEmpty
                      ? Image.network(
                          post.attachmentUrl!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://res.cloudinary.com/dlipvbdwi/image/upload/v1696896650/cld-sample.jpg',
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.network(
                          'https://res.cloudinary.com/dlipvbdwi/image/upload/v1696896650/cld-sample.jpg',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
            ),
          ),

          // Post content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with ellipsis for overflow
                  Text(
                    post.title ?? 'Untitled Post',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  // Post info row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        post.createdDate != null
                            ? DateFormat('MMM d, yyyy')
                                .format(post.createdDate!)
                            : 'Unknown date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.comment,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${post.commentCount ?? 0}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),

                  // Thêm nút Xem chi tiết
                  // Spacer(),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () =>
                  //         controller.goToCommunityPostDetail(index),
                  //     icon: Icon(Icons.visibility, size: 16),
                  //     label: Text('Details', style: TextStyle(fontSize: 12)),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color(0xFFAD6E8C),
                  //       foregroundColor: Colors.white,
                  //       padding: EdgeInsets.symmetric(vertical: 6),
                  //       minimumSize: Size(0, 30),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
