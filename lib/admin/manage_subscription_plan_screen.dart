import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/manage_subscription_plan_controller.dart';
import '../models/subscription_plan_model.dart';

class ManageSubscriptionPlanScreen
    extends GetView<ManageSubscriptionPlanController> {
  const ManageSubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans Management'),
        backgroundColor: const Color(0xFFE5D1E8),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getSubscriptionPlanList(),
            tooltip: 'Refresh Plans',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8EEF6), // Light pastel pink
              Color(0xFFF5E1EB), // Pastel pink
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchFilter(),
            _buildPlansDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFEBD7E6), // Light pastel pink with a hint of purple
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription Plans Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF614051),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Manage all subscription plans, update pricing, and modify available features',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () => controller.goToCreateSubscriptionPlan(),
            icon: Icon(Icons.add_circle_outline),
            label: Text('Create New Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8E6C88),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Search text field
          Expanded(
            flex: 3,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search subscription plans...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF8E6C88)),
                  suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: controller.clearFilters,
                        )
                      : SizedBox.shrink()),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
          ),

          // Status filter dropdown
          SizedBox(width: 16),
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
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedStatus.value,
                      icon: Icon(Icons.filter_list, color: Color(0xFF8E6C88)),
                      hint: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Status'),
                      ),
                      items: ['All', 'Active', 'Inactive'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
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

          // Clear filters button (only shown when filters are applied)
          SizedBox(width: 16),
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty ||
                controller.selectedStatus.value != 'All') {
              return Container(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.clearFilters,
                  icon: Icon(Icons.clear_all),
                  label: Text('Clear Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8E6C88),
                    foregroundColor: Colors.white,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildPlansDataTable() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAD6E8C)),
            ),
          );
        }

        if (controller.filteredSubscriptionPlanList.isEmpty) {
          if (controller.searchQuery.value.isNotEmpty ||
              controller.selectedStatus.value != 'All') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_list_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No plans match your filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try changing your search terms or filter settings',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.clearFilters,
                    icon: Icon(Icons.clear_all),
                    label: Text('Clear Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8E6C88),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Show regular empty state when not searching
            return _buildEmptyState();
          }
        }

        return Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
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
                    Color(0xFFF5E1EB),
                  ),
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price (VND)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Duration (Days)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Created Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                  ],
                  rows: controller.filteredSubscriptionPlanList.map((plan) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${plan.id}')),
                        DataCell(Text(plan.name ?? 'N/A')),
                        DataCell(
                            Text(NumberFormat('#,###').format(plan.price))),
                        DataCell(Text('${plan.duration} days')),
                        DataCell(
                          Container(
                            width: 250,
                            child: Text(
                              plan.description ?? 'No description',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: plan.status == 'Active'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              plan.status == 'Active' ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            plan.createdDate != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(plan.createdDate!)
                                : 'N/A',
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  plan.status == 'Active'
                                      ? Icons.toggle_on
                                      : Icons.toggle_off,
                                  color: plan.status == 'Active'
                                      ? Colors.green
                                      : Colors.red,
                                  size: 28,
                                ),
                                onPressed: () => _showStatusConfirmDialog(plan),
                                tooltip: plan.status == 'Active'
                                    ? 'Deactivate Plan'
                                    : 'Activate Plan',
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditPlanDialog(plan),
                                tooltip: 'Edit Plan',
                              ),
                              IconButton(
                                icon:
                                    Icon(Icons.info, color: Color(0xFF8E6C88)),
                                onPressed: () => _showPlanDetailsDialog(plan),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No subscription plans found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first subscription plan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.goToCreateSubscriptionPlan(),
            icon: Icon(Icons.add),
            label: Text('Create Plan'),
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

  void _showStatusConfirmDialog(SubscriptionPlanModel plan) {
    final bool isCurrentlyActive = plan.status == 'Active';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCurrentlyActive ? Icons.toggle_off : Icons.toggle_on,
                size: 48,
                color: isCurrentlyActive ? Colors.red : Colors.green,
              ),
              SizedBox(height: 24),
              Text(
                isCurrentlyActive ? 'Deactivate Plan?' : 'Activate Plan?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                isCurrentlyActive
                    ? 'Are you sure you want to deactivate this plan? Users will no longer be able to purchase it.'
                    : 'Are you sure you want to activate this plan? This will make it available for purchase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // Call method to toggle plan status
                      // controller.togglePlanStatus(plan.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCurrentlyActive ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  void _showEditPlanDialog(SubscriptionPlanModel plan) {
    // This would be expanded with form fields for editing the plan
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Subscription Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Edit functionality would be implemented here',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E6C88),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlanDetailsDialog(SubscriptionPlanModel plan) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFE5D1E8).withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.card_membership,
                      color: Color(0xFF8E6C88),
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name ?? 'N/A',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF614051),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${plan.duration} days subscription',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildDetailItem('Plan ID', '${plan.id}'),
              _buildDetailItem(
                  'Price', '${NumberFormat('#,###').format(plan.price)} VND'),
              _buildDetailItem('Duration', '${plan.duration} days'),
              _buildDetailItem(
                  'Status', plan.status == 'Active' ? 'Active' : 'Inactive'),
              _buildDetailItem(
                'Created Date',
                plan.createdDate != null
                    ? DateFormat('dd/MM/yyyy').format(plan.createdDate!)
                    : 'N/A',
              ),
              _buildDetailItem('Description',
                  plan.description ?? 'No description available'),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8E6C88),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Close'),
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
              style: TextStyle(
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

  Widget _buildColumnHeader(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF614051),
        ),
      ),
    );
  }
}
