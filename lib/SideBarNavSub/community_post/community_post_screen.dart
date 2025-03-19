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
        decoration: const BoxDecoration(
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF5E1EB), // Soft pink
                    Color(0xFFE5D1E8), // Soft lavender
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.forum_rounded,
                        size: 36,
                        color:
                            Color(0xFFAD6E8C), // Mauve/pink for pregnancy theme
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'COMMUNITY POSTS',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAD6E8C), // Matching mauve color
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      // Get the account controller

                      // Only show Create Post button if user is not a regular user
                      if (!accountController.isRegularUser())
                        _buildActionButton(
                          icon: Icons.add_circle_outline,
                          label: 'Create Post',
                          color: const Color(0xFF8E6C88),
                          onTap: () => controller.goToCreateCommunityPost(),
                        ),
                      const SizedBox(width: 16),
                      // Refresh button
                      _buildActionButton(
                        icon: Icons.refresh,
                        label: 'Refresh',
                        color: const Color(0xFF6F9EAF), // Soft blue/teal
                        onTap: () => controller.getCommunityPostList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'The community post is a place to share your journey, connect with other expecting parents, and find support.',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF8E6C88).withOpacity(0.8),
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(0xFF8E6C88),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
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
                  const SizedBox(width: 15),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Obx(() => DropdownButton<String>(
                            value: controller.selectedFilter.value,
                            icon: const Icon(Icons.filter_list,
                                color: Color(0xFF8E6C88)),
                            items: ['Recent', 'Most Comments', 'Oldest']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.setFilter(newValue);
                              }
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),

            // Thêm sau phần search bar
            Obx(() {
              if (controller.searchQuery.value.isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text('Search results for: ',
                          style: TextStyle(color: Colors.grey[700])),
                      Text('"${controller.searchQuery.value}"',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFAD6E8C))),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear'),
                        onPressed: () => controller.searchController.clear(),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Grid of community posts
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFAD6E8C)),
                    ),
                  );
                }

                if (controller.filteredPostList.isEmpty) {
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
                    itemCount: controller.filteredPostList.length,
                    itemBuilder: (context, index) {
                      final post = controller.filteredPostList[index];
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
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
          const SizedBox(height: 16),
          Text(
            'No community posts yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your journey',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.goToCreateCommunityPost(),
            icon: const Icon(Icons.add),
            label: const Text('Create Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8E6C88),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    // Get the current user's ID to check if they are the author
    final accountController = Get.find<AccountProfileController>();
    final currentUserId = accountController.accountProfileModel.value.id;
    final isAuthor = post.userId == currentUserId;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image (if available)
          Stack(
            children: [
              GestureDetector(
                onTap: () => controller.goToCommunityPostDetail(index),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: post.attachmentUrl != null &&
                          post.attachmentUrl!.isNotEmpty
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
              // Add edit/delete buttons for the author
              if (isAuthor)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      // Edit button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFF8E6C88)),
                          onPressed: () =>
                              controller.goToUpdateCommunityPost(post),
                          tooltip: 'Edit Post',
                          iconSize: 20,
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Delete button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              controller.showDeleteConfirmation(post.id!),
                          tooltip: 'Delete Post',
                          iconSize: 20,
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
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
                  const SizedBox(height: 6),
                  // Post info row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
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
                      const Spacer(),
                      Icon(
                        Icons.comment,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentCount ?? 0}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
