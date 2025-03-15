import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_community_post_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateCommunityPostScreen extends GetView<CreateCommunityPostController> {
  const CreateCommunityPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8EEF6), // Hồng pastel nhạt
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Form(
                    key: controller.communityPostFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Attachment Section
                        _buildSectionHeading('Attachment', Icons.image),
                        _buildAttachmentSection(),

                        SizedBox(height: 25),
                        // Title & Description
                        _buildSectionHeading('Title', Icons.title),
                        _buildTitleField(),

                        SizedBox(height: 25),
                        // Content Section
                        _buildSectionHeading('Content', Icons.description),
                        _buildContentField(),

                        SizedBox(height: 40),

                        // Submit Button
                        _buildSubmitButton(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with gradient background
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 30, 40, 20),
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
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFAD6E8C),
                ),
                onPressed: () => Get.back(),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.create_rounded,
                size: 32,
                color: Color(0xFFAD6E8C),
              ),
              SizedBox(width: 15),
              Text(
                'Create Community Post',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAD6E8C),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              'Share your experiences, ask questions, or connect with other parents',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF8E6C88).withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section heading with icon
  Widget _buildSectionHeading(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFFAD6E8C),
            size: 24,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8E6C88),
            ),
          ),
        ],
      ),
    );
  }

  // Title text field
  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller.titleController,
        validator: (value) => controller.validateTitle(value!),
        decoration: InputDecoration(
          hintText: 'Enter your post title',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: Icon(
            Icons.edit_note,
            color: Color(0xFF8E6C88),
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  // Content text field
  Widget _buildContentField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller.contentController,
        validator: (value) => controller.validateContent(value!),
        maxLines: 12,
        decoration: InputDecoration(
          hintText: 'Share your story or ask a question...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          height: 1.5,
        ),
      ),
    );
  }

  // Attachment section with preview
  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image selection button
        ElevatedButton.icon(
          onPressed: controller.pickImageFromGallery,
          icon: Icon(Icons.add_photo_alternate),
          label: Text('Select Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8E6C88),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 15),

        // Image preview
        Obx(
          () => controller.isImageSelected.value
              ? Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildImagePreview(),
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
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.close,
                            color: Colors.red[400],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No image selected',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Click the button above to select an image',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
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

  // Hàm hiển thị ảnh đã chọn với hỗ trợ Web
  Widget _buildImagePreview() {
    if (!controller.isImageSelected.value) return SizedBox();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: kIsWeb
          // Hiển thị ảnh trên web
          ? (controller.webImage.value != null
              ? Image.memory(
                  controller.webImage.value!,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.contain,
                )
              : Container(
                  height: 350,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(child: Text('Loading image...')),
                ))
          // Hiển thị ảnh trên mobile
          : Image.file(
              File(controller.selectedImage.value!.path),
              height: 350,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
    );
  }

  // Submit button
  Widget _buildSubmitButton() {
    return Center(
      child: Obx(() => SizedBox(
            width: 260,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.createCommunityPost(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAD6E8C),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Color(0xFFAD6E8C).withOpacity(0.6),
                elevation: 3,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: controller.isLoading.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Creating post...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded),
                        SizedBox(width: 10),
                        Text(
                          'Create Post',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          )),
    );
  }
}
