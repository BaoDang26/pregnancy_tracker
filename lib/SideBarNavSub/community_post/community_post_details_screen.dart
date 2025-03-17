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
                const Color(0xFFF8F4FF),
                Color(0xFFF0F8FF),
              ],
            ),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAD6E8C)),
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

            return CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: const Color(0xFFAD6E8C),
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'Community Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFAD6E8C),
                            Color(0xFF8E6C88),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people_outline,
                                color: Colors.white.withOpacity(0.9),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pregnancy Community',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    // Chỉ hiển thị nút sửa và xóa khi người dùng có quyền
                    if (controller.canEditPost())
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () => controller.goToUpdateCommunityPost(
                            controller.communityPost.value!.id!),
                        tooltip: 'Edit Post',
                      ),
                    if (controller.canEditPost())
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => controller.deletePost(),
                        tooltip: 'Delete Post',
                      ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border,
                          color: Colors.white),
                      onPressed: () {
                        // Bookmark functionality can be added here
                        Get.snackbar(
                          'Bookmark',
                          'Post saved for later',
                          colorText: Colors.white,
                          backgroundColor:
                              const Color(0xFFAD6E8C).withOpacity(0.8),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        // Share functionality can be added here
                        Get.snackbar(
                          'Share',
                          'Sharing options',
                          colorText: Colors.white,
                          backgroundColor:
                              const Color(0xFFAD6E8C).withOpacity(0.8),
                        );
                      },
                    ),
                  ],
                ),

                // Post Content
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                        // Post Header
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Post Title
                              Text(
                                controller.communityPost.value?.title ??
                                    'Untitled Post',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF614051),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Post Meta Info
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFFE1BEE7),
                                    radius: 20,
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFF8E6C88),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "User #${controller.communityPost.value?.userId ?? 'Unknown'}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF614051),
                                        ),
                                      ),
                                      Text(
                                        controller.formatDate(controller
                                            .communityPost.value?.createdDate),
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
                                      color: const Color(0xFFE1BEE7)
                                          .withOpacity(0.3),
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
                        Divider(
                            height: 1, thickness: 1, color: Colors.grey[200]),

                        // Post Image (if any)
                        if (controller.communityPost.value?.attachmentUrl !=
                                null &&
                            controller
                                .communityPost.value!.attachmentUrl!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
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
                                              controller.communityPost.value!
                                                  .attachmentUrl!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Positioned(
                                            top: 40,
                                            right: 20,
                                            child: IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: 30),
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
                                    controller
                                        .communityPost.value!.attachmentUrl!,
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

                        // Post Content
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            controller.communityPost.value?.content ??
                                'No content',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Comments Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Color(0xFF8E6C88),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Comments (${controller.comments.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF614051),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Add Comment Section
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Obx(() => ElevatedButton.icon(
                                        onPressed: controller
                                                .isSubmittingComment.value
                                            ? null
                                            : () => controller.createComment(),
                                        icon: controller
                                                .isSubmittingComment.value
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : const Icon(Icons.send),
                                        label: const Text('Post Comment'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFAD6E8C),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                ),

                // Comments List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final comment = controller.comments[index];

                      // Sử dụng ValueBuilder để theo dõi thay đổi của editingCommentId
                      return Obx(() {
                        // Lấy giá trị hiện tại của editingCommentId
                        final isEditing =
                            controller.editingCommentId.value == comment.id;

                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Color(0xFFE1BEE7),
                                      radius: 18,
                                      child: Icon(
                                        Icons.person,
                                        color: Color(0xFF8E6C88),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "User #${comment.userId ?? 'Unknown'}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color(0xFF614051),
                                                ),
                                              ),
                                              if (controller
                                                  .canEditComment(comment))
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFE1BEE7)
                                                            .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                            controller.formatDate(
                                                comment.createdDate),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Edit/Delete Options
                                    if (controller.canEditComment(comment) &&
                                        !isEditing)
                                      PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey[600],
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            controller
                                                .startEditingComment(comment);
                                          } else if (value == 'delete') {
                                            controller
                                                .deleteComment(comment.id!);
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

                              // Comment Content - sử dụng isEditing để quyết định hiển thị gì
                              if (!isEditing)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(46, 0, 16, 16),
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
                                // Form chỉnh sửa comment
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(46, 0, 16, 16),
                                  child: Form(
                                    key: controller.updateCommentFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: controller
                                              .updateCommentController,
                                          validator: (value) => controller
                                              .validateComment(value ?? ''),
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey[100],
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(12),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => controller
                                                  .cancelEditingComment(),
                                              child: const Text('Cancel'),
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: controller
                                                      .isUpdatingComment.value
                                                  ? null
                                                  : () => controller
                                                      .updateComment(),
                                              child: controller
                                                      .isUpdatingComment.value
                                                  ? const SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : const Text('Update'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFAD6E8C),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                    childCount: controller.comments.length,
                  ),
                ),

                // Empty State for No Comments
                if (controller.comments.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                    ),
                  ),

                // Bottom Padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
