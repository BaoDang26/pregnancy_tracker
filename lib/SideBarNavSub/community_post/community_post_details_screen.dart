import 'package:flutter/material.dart';

import '../../controllers/community_post_details_controller.dart';
import '../../util/app_export.dart';

class CommunityPostDetailsScreen
    extends GetView<CommunityPostDetailsController> {
  const CommunityPostDetailsScreen({super.key});

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
                          onPressed: () =>
                              Get.offAllNamed(AppRoutes.sidebarnar, arguments: {
                            'selectedIndex': 1,
                          }),
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
            onPressed: () => Get.offAllNamed(AppRoutes.sidebarnar, arguments: {
              'selectedIndex': 1,
            }),
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
          // TextButton.icon(
          //   icon: Icon(Icons.people_outline),
          //   label: Text('Community'),
          //   onPressed: () => Get.back(),
          //   style: TextButton.styleFrom(
          //     foregroundColor: const Color(0xFF8E6C88),
          //     backgroundColor: const Color(0xFFE1BEE7).withOpacity(0.2),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Breadcrumb navigation
  Widget _buildBreadcrumb() {
    return Row(
      children: [
        TextButton(
          onPressed: () => Get.offAllNamed(AppRoutes.sidebarnar, arguments: {
            'selectedIndex': 1,
          }),
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

        // Form thêm bình luận
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
          child: controller.canComment()
              ? Form(
                  key: controller.commentFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Share your thoughts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.commentController,
                        validator: (value) =>
                            controller.validateComment(value ?? ''),
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          fillColor: Colors.grey[100],
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(() => ElevatedButton.icon(
                              onPressed: controller.isSubmittingComment.value
                                  ? null
                                  : () => controller.createComment(),
                              icon: controller.isSubmittingComment.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.send),
                              label: const Text('Post Comment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAD6E8C),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF8E6C88),
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Limited Access',
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
                      'Regular users cannot comment on posts. Please subscribe to Premium to comment on posts.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
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
        return Obx(() {
          final isEditing = controller.editingCommentId.value == comment.id;

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
                            Row(
                              children: [
                                Text(
                                  "${comment.fullName ?? 'Unknown'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF614051),
                                  ),
                                ),
                                if (controller.canEditComment(comment))
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE1BEE7)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'You',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF8E6C88),
                                      ),
                                    ),
                                  ),
                              ],
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
                      if (controller.canEditComment(comment) && !isEditing)
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey[600],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              controller.startEditingComment(comment);
                            } else if (value == 'delete') {
                              controller.deleteComment(comment.id!);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Color(0xFF8E6C88),
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red[400],
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Comment Content - edit mode or display mode
                if (!isEditing)
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
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(54, 0, 24, 20),
                    child: Form(
                      key: controller.updateCommentFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: controller.updateCommentController,
                            validator: (value) =>
                                controller.validateComment(value ?? ''),
                            maxLines: 3,
                            decoration: InputDecoration(
                              fillColor: Colors.grey[100],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    controller.cancelEditingComment(),
                                child: const Text('Cancel'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: controller.isUpdatingComment.value
                                    ? null
                                    : () => controller.updateComment(),
                                child: controller.isUpdatingComment.value
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text('Update'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAD6E8C),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
        });
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
                onTap: () => Get.offAllNamed(AppRoutes.sidebarnar, arguments: {
                  'selectedIndex': 1,
                }),
              ),
              // const SizedBox(height: 12),
              // _buildSidebarItem(
              //   icon: Icons.add_circle_outline,
              //   title: 'Create Post',
              //   subtitle: 'Share your thoughts with the community',
              //   onTap: () {

              //   },
              // ),
              // const SizedBox(height: 12),
              // _buildSidebarItem(
              //   icon: Icons.bookmark_border,
              //   title: 'Saved Posts',
              //   subtitle: 'View your saved posts',
              //   onTap: () {},
              // ),
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
              const SizedBox(height: 12),
              // TextButton(
              //   onPressed: () {},
              //   child: const Text('Read Full Guidelines'),
              //   style: TextButton.styleFrom(
              //     foregroundColor: const Color(0xFFAD6E8C),
              //     padding: EdgeInsets.zero,
              //   ),
              // ),
            ],
          ),
        ),
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
