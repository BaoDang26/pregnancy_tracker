import 'package:flutter/material.dart';

import '../../controllers/community_post_guest_details_controller.dart';
import '../../util/app_export.dart';
import 'package:intl/intl.dart';

class CommunityPostGuestDetailsScreen
    extends GetView<CommunityPostGuestDetailsController> {
  const CommunityPostGuestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFDF4F9),
                Color(0xFFF8F4FF),
                Color(0xFFF0F8FF),
              ],
            ),
          ),
          // Sử dụng Center và ConstrainedBox để giới hạn chiều rộng tối đa
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFAD6E8C)),
                    ),
                  );
                }

                if (controller.communityPost.value == null ||
                    controller.communityPost.value?.status?.toLowerCase() !=
                        'active') {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: const Color(0xFFAD6E8C).withOpacity(0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.communityPost.value == null
                              ? 'Post not found'
                              : 'This post is no longer available',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8E6C88),
                          ),
                        ),
                        if (controller.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              controller.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red[400],
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Go Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAD6E8C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Header kiểu website
                    _buildWebsiteHeader(),

                    // Container cho nội dung chính
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cột nội dung chính (2/3 chiều rộng)
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Breadcrumb
                                  _buildBreadcrumb(),
                                  const SizedBox(height: 16),

                                  // Nội dung bài viết
                                  _buildPostContent(),
                                  const SizedBox(height: 24),

                                  // Banner Join Community (Chỉ có ở guest view)
                                  _buildJoinCommunityBanner(),
                                  const SizedBox(height: 24),

                                  // Phần bình luận
                                  _buildCommentsSection(),
                                ],
                              ),
                            ),
                          ),

                          // Sidebar (1/3 chiều rộng)
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 16,
                              ),
                              child: _buildSidebar(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Header kiểu website với menu và logo
  Widget _buildWebsiteHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.home_outlined),
            label: const Text('Home'),
            onPressed: () => controller.navigateToHome(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF8E6C88),
            ),
          ),
          const SizedBox(width: 16),
          const Row(
            children: [
              Icon(
                Icons.forum_outlined,
                color: Color(0xFFAD6E8C),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Community Post',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Menu điều hướng

          const SizedBox(width: 16),
          // Button đăng nhập dành cho guest
          TextButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Login'),
            onPressed: () => controller.navigateToLogin(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFAD6E8C),
              backgroundColor: const Color(0xFFE1BEE7).withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  // Breadcrumb navigation
  Widget _buildBreadcrumb() {
    return Row(
      children: [
        TextButton(
          onPressed: () => controller.navigateToHome(),
          child: const Text('Community'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
            padding: const EdgeInsets.all(0),
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
        Icon(Icons.chevron_right, size: 18, color: Colors.grey[500]),
        Expanded(
          child: Text(
            controller.communityPost.value?.title ?? 'Post Details',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFAD6E8C),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Nội dung bài viết
  Widget _buildPostContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Tiêu đề và thông tin tác giả
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề bài viết
                Text(
                  controller.communityPost.value?.title ?? 'Untitled Post',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF614051),
                  ),
                ),
                const SizedBox(height: 16),

                // Thông tin tác giả và ngày đăng
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE1BEE7),
                      radius: 20,
                      backgroundImage:
                          controller.communityPost.value?.avatarUrl != null
                              ? NetworkImage(
                                  controller.communityPost.value!.avatarUrl!)
                              : null,
                      child: controller.communityPost.value?.avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Color(0xFF8E6C88),
                              size: 22,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.communityPost.value?.fullName ?? 'Unknown'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF614051),
                          ),
                        ),
                        Text(
                          controller.formatDate(
                              controller.communityPost.value?.createdDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1BEE7).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.comment_outlined,
                            size: 16,
                            color: Color(0xFF8E6C88),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${controller.communityPost.value?.commentCount ?? 0}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8E6C88),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),

          // Hình ảnh (nếu có)
          if (controller.communityPost.value?.attachmentUrl != null &&
              controller.communityPost.value!.attachmentUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    // Hiển thị ảnh full màn hình khi nhấn vào
                    Get.dialog(
                      Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.zero,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            InteractiveViewer(
                              child: Image.network(
                                controller.communityPost.value!.attachmentUrl!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: 20,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 30),
                                onPressed: () => Get.back(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 100,
                      maxHeight: 400,
                    ),
                    width: double.infinity,
                    child: Image.network(
                      controller.communityPost.value!.attachmentUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

          // Nội dung bài viết
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              controller.communityPost.value?.content ?? 'No content',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Banner Join Community (đặc thù cho guest view)
  Widget _buildJoinCommunityBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFAD6E8C).withOpacity(0.9),
            const Color(0xFF8E6C88).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.forum_outlined,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join the conversation!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Login or create an account to add comments and connect with other parents',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // Phần bình luận
  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề phần bình luận
        Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF8E6C88),
            ),
            const SizedBox(width: 8),
            Text(
              'Comments (${controller.comments.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF614051),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Form đăng nhập để bình luận (dành cho guest)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              const Row(
                children: [
                  Icon(
                    Icons.login_outlined,
                    color: Color(0xFF8E6C88),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Sign in to comment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Join our community to share your thoughts and experiences with other parents.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Danh sách bình luận
        _buildCommentsList(),
      ],
    );
  }

  // Danh sách bình luận
  Widget _buildCommentsList() {
    if (controller.comments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: const Color(0xFFAD6E8C).withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF614051),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share your thoughts on this post',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.comments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final comment = controller.comments[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Comment Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE1BEE7),
                      radius: 18,
                      backgroundImage: comment.avatarUrl != null
                          ? NetworkImage(comment.avatarUrl!)
                          : null,
                      child: comment.avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Color(0xFF8E6C88),
                              size: 20,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${comment.fullName ?? 'Unknown'}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF614051),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.formatDate(comment.createdDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Comment Content
              Padding(
                padding: const EdgeInsets.fromLTRB(54, 0, 24, 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    comment.content ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Sidebar với thông tin và các bài viết liên quan
  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thông tin cộng đồng
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              const Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Color(0xFFAD6E8C),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Community',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSidebarItem(
                icon: Icons.forum_outlined,
                title: 'Posts',
                subtitle: 'View all community posts',
                onTap: () => controller.navigateToHome(),
              ),
              const SizedBox(height: 12),
              _buildSidebarItem(
                icon: Icons.login,
                title: 'Join Community',
                subtitle: 'Sign in to interact with posts',
                onTap: () => controller.navigateToLogin(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Quy tắc cộng đồng
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              const Row(
                children: [
                  Icon(
                    Icons.rule,
                    color: Color(0xFFAD6E8C),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Community Guidelines',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Be respectful and supportive of other members. Share your experiences but avoid medical advice.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // Join Community Box (đặc thù cho guest)
        const SizedBox(height: 24),
      ],
    );
  }

  // Item cho sidebar
  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE1BEE7).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFAD6E8C),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
