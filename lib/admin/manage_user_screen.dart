import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/manage_user_controller.dart';
import '../models/user_model.dart';

class ManageUserScreen extends GetView<ManageUserController> {
  const ManageUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: const Color(0xFF8E6C88),
        elevation: 0,
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF5E1EB).withOpacity(0.5),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchFilter(),
            if (controller.searchQuery.value.isNotEmpty ||
                controller.selectedRole.value != 'All Roles' ||
                controller.selectedStatus.value != 'All Statuses')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Chip(
                      label: Text('Filters applied'),
                      backgroundColor: Color(0xFFEBD7E6),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear all filters'),
                      onPressed: () => controller.clearFilters(),
                    ),
                  ],
                ),
              ),
            _buildUserDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Management Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF614051),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Manage all users, update statuses, and monitor account activities',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search users by name or email...',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF8E6C88)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: Obx(
                    () => controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.searchController.clear();
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedRole.value,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Filter by Role'),
                      ),
                      icon: const Icon(Icons.filter_list,
                          color: Color(0xFF8E6C88)),
                      items: ['All Roles', 'ROLE_USER', 'ROLE_USER_PREMIUM']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.setRoleFilter(newValue);
                        }
                      },
                    ),
                  )),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedStatus.value,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Filter by Status'),
                      ),
                      icon: const Icon(Icons.filter_list,
                          color: Color(0xFF8E6C88)),
                      items: ['All Statuses', 'Active', 'Deactive']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.setStatusFilter(newValue);
                        }
                      },
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDataTable() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAD6E8C)),
            ),
          );
        }

        if (controller.userList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 72,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    const Color(0xFFF5E1EB),
                  ),
                  columnSpacing: 20,
                  columns: [
                    const DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Role',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                  ],
                  rows: controller.filteredUserList.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${user.id}')),
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: user.avatarUrl != null &&
                                        user.avatarUrl!.isNotEmpty
                                    ? NetworkImage(user.avatarUrl!)
                                    : null,
                                child: user.avatarUrl == null ||
                                        user.avatarUrl!.isEmpty
                                    ? Text(
                                        user.fullName != null &&
                                                user.fullName!.isNotEmpty
                                            ? user.fullName![0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    : null,
                                backgroundColor: Colors.purple[200],
                              ),
                              const SizedBox(width: 10),
                              Text(user.fullName ?? 'N/A'),
                            ],
                          ),
                        ),
                        DataCell(Text(user.email ?? 'N/A')),
                        DataCell(Text(user.address ?? 'N/A')),
                        DataCell(Text(
                          user.dateOfBirth != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(user.dateOfBirth!)
                              : 'N/A',
                        )),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _getRoleColor(user.roleName),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.roleName ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _getStatusColor(user.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.status ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  user.status?.toLowerCase() == 'active'
                                      ? Icons.block
                                      : Icons.check_circle,
                                  color: user.status?.toLowerCase() == 'active'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                onPressed: () => _showStatusConfirmDialog(user),
                                tooltip: user.status?.toLowerCase() == 'active'
                                    ? 'Deactivate User'
                                    : 'Activate User',
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.edit, color: Colors.blue),
                              //   onPressed: () => _showEditUserDialog(user),
                              //   tooltip: 'Edit User',
                              // ),
                              IconButton(
                                icon: const Icon(Icons.info,
                                    color: Color(0xFF8E6C88)),
                                onPressed: () => _showUserDetailsDialog(user),
                                tooltip: 'View Details',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _getRoleColor(String? role) {
    if (role == null) return Colors.grey;

    switch (role.toUpperCase()) {
      case 'ROLE_ADMIN':
        return Colors.purple;
      case 'ROLE_USER':
        return Colors.blue;
      case 'ROLE_PREMIUM':
        return Colors.amber[700]!;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'INACTIVE':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showStatusConfirmDialog(UserModel user) {
    final bool isCurrentlyActive = user.status?.toLowerCase() == 'active';
    final String newStatus = isCurrentlyActive ? 'inactive' : 'active';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCurrentlyActive ? Icons.block : Icons.check_circle,
                size: 48,
                color: isCurrentlyActive ? Colors.red : Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                isCurrentlyActive ? 'Deactivate User?' : 'Activate User?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isCurrentlyActive
                    ? 'Are you sure you want to deactivate this user? They will no longer be able to access the system.'
                    : 'Are you sure you want to activate this user? This will restore their access to the system.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.updateStatusUser(user.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCurrentlyActive ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      isCurrentlyActive ? 'Deactivate' : 'Activate',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserDetailsDialog(UserModel user) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                            ? NetworkImage(user.avatarUrl!)
                            : null,
                    child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                        ? Text(
                            user.fullName != null && user.fullName!.isNotEmpty
                                ? user.fullName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          )
                        : null,
                    backgroundColor: const Color(0xFFAD6E8C),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailItem('User ID', '${user.id}'),
              _buildDetailItem('Role', user.roleName ?? 'N/A'),
              _buildDetailItem('Status', user.status ?? 'N/A'),
              _buildDetailItem('Address', user.address ?? 'N/A'),
              _buildDetailItem(
                'Date of Birth',
                user.dateOfBirth != null
                    ? DateFormat('yyyy-MM-dd').format(user.dateOfBirth!)
                    : 'N/A',
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E6C88),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label + ':',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF614051),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
