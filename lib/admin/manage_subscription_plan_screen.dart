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
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            const Color(0xFFEBD7E6), // Light pastel pink with a hint of purple
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subscription Plans Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF614051),
                  ),
                ),
                const SizedBox(height: 10),
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
          const SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () => controller.goToCreateSubscriptionPlan(),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Create New Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8E6C88),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      padding: const EdgeInsets.all(16),
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
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search subscription plans...',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF8E6C88)),
                  suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: controller.clearFilters,
                        )
                      : const SizedBox.shrink()),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
          ),

          // Status filter dropdown
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
                      icon: const Icon(Icons.filter_list,
                          color: Color(0xFF8E6C88)),
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Status'),
                      ),
                      items: ['All', 'Active', 'Deactive'].map((String value) {
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

          // Clear filters button (only shown when filters are applied)
          const SizedBox(width: 16),
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty ||
                controller.selectedStatus.value != 'All') {
              return Container(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.clearFilters,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E6C88),
                    foregroundColor: Colors.white,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildPlansDataTable() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
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
                  const SizedBox(height: 16),
                  Text(
                    'No plans match your filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try changing your search terms or filter settings',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.clearFilters,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E6C88),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
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
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Price (VND)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Duration (Days)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Description',
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
                        'Created Date',
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: plan.status == 'Active'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              plan.status == 'Active' ? 'Active' : 'Deactive',
                              style: const TextStyle(
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
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditPlanDialog(plan),
                                tooltip: 'Edit Plan',
                              ),
                              IconButton(
                                icon: const Icon(Icons.info,
                                    color: Color(0xFF8E6C88)),
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
          const SizedBox(height: 16),
          Text(
            'No subscription plans found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first subscription plan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.goToCreateSubscriptionPlan(),
            icon: const Icon(Icons.add),
            label: const Text('Create Plan'),
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

  void _showStatusConfirmDialog(SubscriptionPlanModel plan) {
    final bool isCurrentlyActive = plan.status == 'Active';

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
                isCurrentlyActive ? Icons.toggle_off : Icons.toggle_on,
                size: 48,
                color: isCurrentlyActive ? Colors.red : Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                isCurrentlyActive ? 'Deactivate Plan?' : 'Activate Plan?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isCurrentlyActive
                    ? 'Are you sure you want to deactivate this plan? Users will no longer be able to purchase it.'
                    : 'Are you sure you want to activate this plan? This will make it available for purchase.',
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
                      // Call method to toggle plan status
                      controller.deactivateSubscriptionPlan(plan.id!);
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

  void _showEditPlanDialog(SubscriptionPlanModel plan) {
    // Điền dữ liệu vào form
    controller.prepareUpdateForm(plan);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Obx(() => Form(
                key: controller.updateSubscriptionPlanFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Row(
                        children: [
                          Icon(Icons.edit,
                              color: const Color(0xFF8E6C88), size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Edit Subscription Plan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF614051),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Plan Name
                      const Text(
                        'Plan Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.updateNameController,
                        validator: (value) => controller.validateName(value!),
                        decoration: const InputDecoration(
                          hintText: 'Enter plan name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      const Text(
                        'Price (VND)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.updatePriceController,
                        validator: (value) => controller.validatePrice(value!),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Duration
                      const Text(
                        'Duration (Days)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.updateDurationController,
                        validator: (value) =>
                            controller.validateDuration(value!),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter duration in days',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF614051),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.updateDescriptionController,
                        validator: (value) =>
                            controller.validateDescription(value!),
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'Enter plan description',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      // Error message
                      if (controller.updateErrorString.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.red[50],
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.updateErrorString.value,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: controller.isUpdating.value
                                ? null
                                : () =>
                                    controller.updateSubscriptionPlan(plan.id!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8E6C88),
                              foregroundColor: Colors.white,
                            ),
                            child: controller.isUpdating.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Update Plan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showPlanDetailsDialog(SubscriptionPlanModel plan) {
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5D1E8).withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_membership,
                      color: Color(0xFF8E6C88),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF614051),
                          ),
                        ),
                        const SizedBox(height: 4),
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
              const SizedBox(height: 24),
              _buildDetailItem('Plan ID', '${plan.id}'),
              _buildDetailItem(
                  'Price', '${NumberFormat('#,###').format(plan.price)} VND'),
              _buildDetailItem('Duration', '${plan.duration} days'),
              _buildDetailItem(
                  'Status', plan.status == 'Active' ? 'Active' : 'Deactive'),
              _buildDetailItem(
                'Created Date',
                plan.createdDate != null
                    ? DateFormat('dd/MM/yyyy').format(plan.createdDate!)
                    : 'N/A',
              ),
              _buildDetailItem('Description',
                  plan.description ?? 'No description available'),
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

  Widget _buildColumnHeader(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF614051),
        ),
      ),
    );
  }
}
