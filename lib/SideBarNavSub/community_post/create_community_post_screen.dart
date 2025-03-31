import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_community_post_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../routes/app_routes.dart';

class CreateCommunityPostScreen extends GetView<CreateCommunityPostController> {
  const CreateCommunityPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            child: Column(
              children: [
                // Header kiểu website
                _buildWebsiteHeader(),

                // Nội dung chính
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form nhập liệu (2/3 chiều rộng)
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Breadcrumb
                              _buildBreadcrumb(),
                              const SizedBox(height: 24),

                              // Form chính
                              _buildPostForm(),
                            ],
                          ),
                        ),
                      ),

                      // Sidebar với hướng dẫn (1/3 chiều rộng)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                          child: _buildSidebar(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header kiểu website với menu
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
            onPressed: () => Get.offAllNamed(AppRoutes.sidebarnar,
                arguments: {'selectedIndex': 1}),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF8E6C88),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: const [
              Icon(
                Icons.create_rounded,
                color: Color(0xFFAD6E8C),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Create Community Post',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // Breadcrumb navigation
  Widget _buildBreadcrumb() {
    return Row(
      children: [
        TextButton(
          onPressed: () => Get.offAllNamed(AppRoutes.sidebarnar,
              arguments: {'selectedIndex': 1}),
          child: const Text('Community'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
            padding: const EdgeInsets.all(0),
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
        Icon(Icons.chevron_right, size: 18, color: Colors.grey[500]),
        const Text(
          'Create Post',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFAD6E8C),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Form nhập liệu chính
  Widget _buildPostForm() {
    return Form(
      key: controller.communityPostFormKey,
      child: Container(
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề form
            const Row(
              children: [
                Icon(
                  Icons.post_add,
                  color: Color(0xFFAD6E8C),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Create New Post',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF614051),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'Share your experiences, ask questions, or connect with other parents',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Các trường nhập liệu
            _buildSectionHeading('Title', Icons.title),
            const SizedBox(height: 8),
            _buildTitleField(),
            const SizedBox(height: 24),

            _buildSectionHeading('Content', Icons.description),
            const SizedBox(height: 8),
            _buildContentField(),
            const SizedBox(height: 24),

            _buildSectionHeading('Attachment', Icons.image),
            const SizedBox(height: 8),
            _buildAttachmentSection(),
            const SizedBox(height: 32),

            // Nút đăng bài
            Center(
              child: Obx(() => SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.createCommunityPost(),
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        controller.isLoading.value
                            ? 'Creating...'
                            : 'Publish Post',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAD6E8C),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFFAD6E8C).withOpacity(0.6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // Tiêu đề mục
  Widget _buildSectionHeading(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFAD6E8C),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8E6C88),
          ),
        ),
      ],
    );
  }

  // Trường nhập tiêu đề
  Widget _buildTitleField() {
    return TextFormField(
      controller: controller.titleController,
      validator: (value) => controller.validateTitle(value!),
      decoration: InputDecoration(
        hintText: 'Enter your post title',
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFAD6E8C), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
      ),
    );
  }

  // Trường nhập nội dung
  Widget _buildContentField() {
    return TextFormField(
      controller: controller.contentController,
      validator: (value) => controller.validateContent(value!),
      maxLines: 10,
      decoration: InputDecoration(
        hintText: 'Share your story or ask a question...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFAD6E8C), width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
        height: 1.5,
      ),
    );
  }

  // Phần chọn ảnh và xem trước
  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nút chọn ảnh
        ElevatedButton.icon(
          onPressed: controller.pickImageFromGallery,
          icon: const Icon(Icons.add_photo_alternate, size: 18),
          label: const Text('Select Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: const Color(0xFF8E6C88),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Xem trước ảnh
        Obx(
          () => controller.isImageSelected.value
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? (controller.webImage.value != null
                                ? Image.memory(
                                    controller.webImage.value!,
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  )
                                : Container(
                                    height: 300,
                                    width: double.infinity,
                                    color: Colors.grey[100],
                                    child: const Center(
                                      child: Text('Loading image...'),
                                    ),
                                  ))
                            : Image.file(
                                File(controller.selectedImage.value!.path),
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: controller.clearSelectedImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.close,
                              color: Colors.red[400],
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No image selected',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // Sidebar với hướng dẫn và quy tắc
  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hướng dẫn đăng bài
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
                    Icons.info_outline,
                    color: Color(0xFFAD6E8C),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Posting Guidelines',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildGuidelineItem(
                icon: Icons.title,
                text: 'Use a clear, specific title',
              ),
              _buildGuidelineItem(
                icon: Icons.description,
                text: 'Add detailed description to get better responses',
              ),
              _buildGuidelineItem(
                icon: Icons.image,
                text: 'Add relevant images (optional)',
              ),
              _buildGuidelineItem(
                icon: Icons.favorite,
                text: 'Be respectful and supportive to community members',
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
            borderRadius: BorderRadius.circular(8),
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
                    'Community Rules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '• Be respectful and kind to others\n'
                '• No spam or promotional content\n'
                '• Do not share personal medical advice\n'
                '• Keep discussions constructive and helpful\n'
                '• Report inappropriate content',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Thông tin hỗ trợ
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F4FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1BEE7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: Color(0xFFAD6E8C),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Need Help?',
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
                'If you have any questions or need assistance, please contact our support team by email.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Item guideline
  Widget _buildGuidelineItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFE1BEE7).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFAD6E8C),
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
