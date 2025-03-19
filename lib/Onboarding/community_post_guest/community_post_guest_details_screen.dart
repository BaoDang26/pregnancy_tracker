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
                const Color(0xFFF0F8FF),
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
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFE1BEE7),
                                    radius: 20,
                                    backgroundImage: controller.communityPost
                                                .value?.avatarUrl !=
                                            null
                                        ? NetworkImage(controller
                                            .communityPost.value!.avatarUrl!)
                                        : null,
                                    child: controller.communityPost.value
                                                ?.avatarUrl ==
                                            null
                                        ? Icon(
                                            Icons.person,
                                            color: Color(0xFF8E6C88),
                                            size: 22,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                // Join Community Banner
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                      borderRadius: BorderRadius.circular(20),
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
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => controller.navigateToLogin(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFAD6E8C),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => controller.navigateToSignUp(),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 0),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Comments Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
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
                        const Spacer(),
                        // Nút đăng nhập với icon comment
                        GestureDetector(
                          onTap: () => controller.navigateToLogin(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1BEE7).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // child: Row(
                            //   children: [
                            //     Icon(
                            //       Icons.add_comment_outlined,
                            //       size: 16,
                            //       color: Color(0xFF8E6C88),
                            //     ),
                            //     SizedBox(width: 6),
                            //     Text(
                            //       'Login to comment',
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //         fontWeight: FontWeight.bold,
                            //         color: Color(0xFF8E6C88),
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFE1BEE7),
                                    radius: 18,
                                    backgroundImage: comment.avatarUrl != null
                                        ? NetworkImage(comment.avatarUrl!)
                                        : null,
                                    child: comment.avatarUrl == null
                                        ? Icon(
                                            Icons.person,
                                            color: Color(0xFF8E6C88),
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          controller
                                              .formatDate(comment.createdDate),
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
                              padding: const EdgeInsets.fromLTRB(46, 0, 16, 16),
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
                          // SizedBox(height: 20),
                          // ElevatedButton.icon(
                          //   onPressed: () => controller.navigateToLogin(),
                          //   icon: Icon(Icons.login_rounded),
                          //   label: Text('Sign in to comment'),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Color(0xFFAD6E8C),
                          //     foregroundColor: Colors.white,
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 20, vertical: 12),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(25),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),

                // Bottom Padding with Sign Up CTA
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
                    // child: Column(
                    //   children: [
                    //     Text(
                    //       'Want to interact with this community?',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //         color: Color(0xFF614051),
                    //       ),
                    //     ),
                    //     SizedBox(height: 16),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         Expanded(
                    //           child: OutlinedButton.icon(
                    //             onPressed: () => controller.navigateToLogin(),
                    //             icon: Icon(Icons.login),
                    //             label: Text('Sign In'),
                    //             style: OutlinedButton.styleFrom(
                    //               foregroundColor: Color(0xFF8E6C88),
                    //               side: BorderSide(color: Color(0xFF8E6C88)),
                    //               padding: EdgeInsets.symmetric(vertical: 12),
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(width: 16),
                    //         Expanded(
                    //           child: ElevatedButton.icon(
                    //             onPressed: () => controller.navigateToSignUp(),
                    //             icon: Icon(Icons.person_add),
                    //             label: Text('Create Account'),
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: Color(0xFFAD6E8C),
                    //               foregroundColor: Colors.white,
                    //               padding: EdgeInsets.symmetric(vertical: 12),
                    //               elevation: 0,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      // Floating action button for registration
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => controller.navigateToSignUp(),
      //   backgroundColor: Color(0xFFAD6E8C),
      //   icon: Icon(Icons.person_add_outlined, color: Colors.white),
      //   label: Text('Join Community', style: TextStyle(color: Colors.white)),
      //   elevation: 4,
      // ),
    );
  }
}
