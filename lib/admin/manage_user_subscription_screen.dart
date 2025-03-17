import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/manage_user_subscription_controller.dart';
import '../models/user_subscription_model.dart';
import '../util/app_export.dart';

class ManageUserSubscriptionScreen
    extends GetView<ManageUserSubscriptionController> {
  const ManageUserSubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage User Subscriptions'),
        backgroundColor: const Color(0xFFE5D1E8),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getAllUserSubscription(),
            tooltip: 'Refresh Data',
          ),
          const SizedBox(width: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSearchAndFilter(),
              const SizedBox(height: 24),
              Expanded(
                child: _buildSubscriptionTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            Icons.subscriptions,
            size: 32,
            color: Color(0xFF614051),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Subscription Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor and manage all user subscription plans',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          Obx(() => Text(
                'Total: ${controller.filteredUserSubscriptionList.length} subscriptions',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search by plan name',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8E6C88)),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF8E6C88), width: 2),
                ),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.onSearchChanged();
              },
            ),
          ),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8E6C88),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_list, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            onSelected: (String result) {
              controller.setStatusFilter(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'all',
                child: Text('All Subscriptions'),
              ),
              const PopupMenuItem<String>(
                value: 'payment_pending',
                child: Text('Payment Pending'),
              ),
              const PopupMenuItem<String>(
                value: 'payment_failed',
                child: Text('Payment Failed'),
              ),
              const PopupMenuItem<String>(
                value: 'payment_success',
                child: Text('Payment Success'),
              ),
              const PopupMenuItem<String>(
                value: 'pending',
                child: Text('Pending'),
              ),
              const PopupMenuItem<String>(
                value: 'finished',
                child: Text('Finished'),
              ),
              const PopupMenuItem<String>(
                value: 'active',
                child: Text('Active'),
              ),
              const PopupMenuItem<String>(
                value: 'expired',
                child: Text('Expired'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E6C88)),
            ),
          );
        } else if (controller.filteredUserSubscriptionList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.subscriptions,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No subscriptions found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(const Color(0xFFEBD7E6)),
                dataRowColor: MaterialStateProperty.all(Colors.white),
                columns: [
                  const DataColumn(label: Text('ID')),
                  const DataColumn(label: Text('Plan Name')),
                  const DataColumn(label: Text('Start Date')),
                  const DataColumn(label: Text('End Date')),
                  const DataColumn(label: Text('Amount (VND)')),
                  const DataColumn(label: Text('Status')),
                  const DataColumn(label: Text('Payment Date')),
                  const DataColumn(label: Text('Actions')),
                ],
                rows:
                    controller.filteredUserSubscriptionList.map((subscription) {
                  return DataRow(cells: [
                    DataCell(Text('${subscription.id}')),
                    DataCell(Text(subscription.subscriptionPlanName ?? 'N/A')),
                    DataCell(Text(subscription.startDate != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(subscription.startDate!)
                        : 'N/A')),
                    DataCell(Text(subscription.endDate != null
                        ? DateFormat('dd/MM/yyyy').format(subscription.endDate!)
                        : 'N/A')),
                    DataCell(Text(NumberFormat('#,###')
                        .format(subscription.amount ?? 0))),
                    DataCell(_buildStatusBadge(subscription.status ?? 'N/A')),
                    DataCell(Text(subscription.paymentDate != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(subscription.paymentDate!)
                        : 'N/A')),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () {
                            _showSubscriptionDetailsDialog(subscription);
                          },
                          tooltip: 'View Details',
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.history, color: Colors.orange),
                        //   onPressed: () {
                        //     // View history action
                        //   },
                        //   tooltip: 'View History',
                        // ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;

    if (status.toLowerCase() == 'active') {
      backgroundColor = Colors.green;
    } else if (status.toLowerCase() == 'expired') {
      backgroundColor = Colors.red;
    } else if (status.toLowerCase() == 'pending') {
      backgroundColor = Colors.orange;
    } else {
      backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showSubscriptionDetailsDialog(UserSubscriptionModel subscription) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Color(0xFF8E6C88), size: 28),
                  const SizedBox(width: 16),
                  const Text(
                    'Subscription Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Content
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  _buildDetailItem('ID', '${subscription.id}', Icons.tag),
                  _buildDetailItem(
                      'Plan Name',
                      subscription.subscriptionPlanName ?? 'N/A',
                      Icons.card_membership),
                  _buildDetailItem('Status', subscription.status ?? 'N/A',
                      Icons.check_circle_outline),
                  _buildDetailItem(
                      'Amount',
                      '${NumberFormat('#,###', 'vi_VN').format(subscription.amount ?? 0)} VND',
                      Icons.attach_money),
                  _buildDetailItem(
                      'Start Date',
                      subscription.startDate != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(subscription.startDate!)
                          : 'N/A',
                      Icons.calendar_today),
                  _buildDetailItem(
                      'End Date',
                      subscription.endDate != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(subscription.endDate!)
                          : 'N/A',
                      Icons.event),
                  _buildDetailItem(
                      'Payment Date',
                      subscription.paymentDate != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(subscription.paymentDate!)
                          : 'N/A',
                      Icons.payment),
                  _buildDetailItem(
                      'Subscription Code',
                      subscription.subscriptionCode ?? 'N/A',
                      Icons.confirmation_number),
                  _buildDetailItem('Bank Code', subscription.bankCode ?? 'N/A',
                      Icons.account_balance),
                  _buildDetailItem('Transaction No',
                      subscription.transactionNo ?? 'N/A', Icons.receipt),
                  _buildDetailItem(
                      'Created Date',
                      subscription.createdDate != null
                          ? DateFormat('dd/MM/yyyy HH:mm')
                              .format(subscription.createdDate!)
                          : 'N/A',
                      Icons.access_time),
                ],
              ),

              const SizedBox(height: 24),

              // Footer
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E6C88),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      width: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8E6C88)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
