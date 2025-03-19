import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import '../../controllers/user_subscription_controller.dart';
import '../../models/user_subscription_model.dart';
import '../../widgets/custom_card_user_subscription_widget.dart';

class UserSubscriptionScreen extends GetView<UserSubscriptionController> {
  const UserSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE8F5E9),
              Color(0xFFC8E6C9),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingState();
                  }

                  if (controller.userSubscriptionList.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildSubscriptionGrid();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF66BB6A),
            Color(0xFF4CAF50),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.history_edu,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Subscription History',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                // child: IconButton(
                //   icon: Icon(
                //     Icons.add_card,
                //     color: Colors.green[700],
                //   ),
                //   onPressed: () {
                //     // Get.toNamed(AppRoutes.subscriptionPlan);
                //   },
                //   tooltip: 'Add Subscription',
                // ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'View and manage your subscription packages',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading your subscriptions...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.subscriptions_outlined,
                size: 80,
                color: Colors.green[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Subscriptions Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Subscribe to unlock premium features and enhance your pregnancy journey',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(
                'Browse Plans',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[50]!, Colors.blue[100]!],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.blue[300]!.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your active and past subscription packages are shown below',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                mainAxisExtent: 350,
              ),
              itemCount: controller.userSubscriptionList.length,
              itemBuilder: (context, index) {
                final subscription = controller.userSubscriptionList[index];
                final isActive = subscription.status == 'active';

                return InkWell(
                  onTap: () => _showSubscriptionDetailsDialog(subscription),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isActive
                            ? [Colors.green[50]!, Colors.green[100]!]
                            : [Colors.grey[50]!, Colors.grey[100]!],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color:
                            isActive ? Colors.green[300]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (isActive)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getIconForPlanName(
                                      subscription.subscriptionPlanName ?? ''),
                                  color: isActive
                                      ? Colors.green[700]
                                      : Colors.grey[700],
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                subscription.subscriptionPlanName ??
                                    'Unknown Plan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? Colors.green[800]
                                      : Colors.grey[800],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              const Divider(),
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.calendar_today,
                                  'Start: ${_formatDate(subscription.startDate)}'),
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.event,
                                  'End: ${_formatDate(subscription.endDate)}'),
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.payments,
                                  '${_formatAmount(subscription.amount?.toDouble() ?? 0.0)} VND'),
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.confirmation_number,
                                  '#${subscription.subscriptionCode ?? ''}'),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    subscription.status ?? 'No information',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: subscription.status == 'PENDING'
                                          ? Colors.green[700]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,###').format(amount.round());
  }

  IconData _getIconForPlanName(String planName) {
    final name = planName.toLowerCase();

    if (name.contains('basic')) return Icons.star_outline;
    if (name.contains('standard')) return Icons.star_half;
    if (name.contains('premium')) return Icons.star;
    if (name.contains('pro')) return Icons.workspace_premium;
    if (name.contains('family')) return Icons.family_restroom;
    if (name.contains('monthly')) return Icons.calendar_month;
    if (name.contains('yearly')) return Icons.calendar_today;

    return Icons.card_membership;
  }

  void _showSubscriptionDetailsDialog(UserSubscriptionModel subscription) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.green[50]!],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForPlanName(
                          subscription.subscriptionPlanName ?? ''),
                      color: Colors.green[700],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'History Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Content
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildDetailItem(
                    'Plan Name',
                    subscription.subscriptionPlanName ?? 'No information',
                    Icons.card_membership,
                  ),
                  _buildDetailItem(
                    'Status',
                    subscription.status ?? 'No information',
                    Icons.info_outline,
                    isStatus: true,
                    statusValue: subscription.status,
                  ),
                  _buildDetailItem(
                    'Amount',
                    '${_formatAmount(subscription.amount?.toDouble() ?? 0.0)} VND',
                    Icons.payments,
                  ),
                  _buildDetailItem(
                    'Start Date',
                    _formatDateDetailed(subscription.startDate),
                    Icons.calendar_today,
                  ),
                  _buildDetailItem(
                    'End Date',
                    _formatDateDetailed(subscription.endDate),
                    Icons.event,
                  ),
                  _buildDetailItem(
                    'Payment Date',
                    _formatDateDetailed(subscription.paymentDate),
                    Icons.date_range,
                  ),
                  _buildDetailItem(
                    'Subscription Code',
                    subscription.subscriptionCode ?? 'No information',
                    Icons.confirmation_number,
                  ),
                  _buildDetailItem(
                    'Bank Code',
                    subscription.bankCode ?? 'No information',
                    Icons.account_balance,
                  ),
                  _buildDetailItem(
                    'Transaction Number',
                    subscription.transactionNo ?? 'No information',
                    Icons.receipt_long,
                  ),
                  // _buildDetailItem(
                  //   'Created Date',
                  //   _formatDateDetailed(subscription.createdDate),
                  //   Icons.create,
                  // ),
                ],
              ),

              const SizedBox(height: 24),

              // Footer
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon,
      {bool isStatus = false, String? statusValue}) {
    Color bgColor = Colors.blue[50]!;
    Color iconColor = Colors.blue[700]!;
    Color textColor = Colors.blue[900]!;

    if (isStatus && statusValue != null) {
      if (statusValue.toLowerCase() == 'active') {
        bgColor = Colors.green[50]!;
        iconColor = Colors.green[700]!;
        textColor = Colors.green[900]!;
      } else if (statusValue.toLowerCase() == 'expired' ||
          statusValue.toLowerCase() == 'canceled') {
        bgColor = Colors.grey[200]!;
        iconColor = Colors.grey[700]!;
        textColor = Colors.grey[900]!;
      } else if (statusValue.toLowerCase().contains('pending')) {
        bgColor = Colors.orange[50]!;
        iconColor = Colors.orange[700]!;
        textColor = Colors.orange[900]!;
      } else if (statusValue.toLowerCase().contains('fail')) {
        bgColor = Colors.red[50]!;
        iconColor = Colors.red[700]!;
        textColor = Colors.red[900]!;
      }
    }

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateDetailed(DateTime? date) {
    if (date == null) return 'No information';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
