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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFC8E6C9),
                ],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
              ),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE8F5E9),
                Color(0xFFC8E6C9),
                Color(0xFFB2DFDB),
              ],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  // Website-style header
                  _buildWebsiteHeader(),

                  // Main content with scrolling
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            // Statistics and summary cards
                            _buildStatisticsSection(),

                            const SizedBox(height: 32),

                            // Subscription timeline and overview section
                            // _buildSubscriptionOverview(),

                            // const SizedBox(height: 32),

                            // History section header
                            _buildSectionHeader(
                              "Subscription History",
                              "Complete record of your premium package purchases",
                              true,
                              onAddPressed: () => Get.back(),
                            ),

                            const SizedBox(height: 16),

                            // Subscription history table
                            controller.userSubscriptionList.isEmpty
                                ? _buildEmptyState()
                                : _buildSubscriptionTable(),

                            const SizedBox(height: 32),

                            // Benefits section
                            _buildBenefitsSection(),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Website-style header with navigation
  Widget _buildWebsiteHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history_edu,
                  color: Colors.green[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Subscription History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                onPressed: () => controller.getUserSubscriptionList(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.subdirectory_arrow_left),
                label: const Text('Subscription Plans'),
                onPressed: () => Get.back(), // Go back to subscription plans
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.grey[700],
          size: 22,
        ),
      ),
    );
  }

  // Statistics cards with key numbers
  Widget _buildStatisticsSection() {
    // Calculate statistics for cards
    int activeSubscriptions = 0;
    int totalSpent = 0;
    int totalDays = 0;
    DateTime? latestEndDate;
    String currentPlan = "None";
    int daysRemaining = 0;

    for (var subscription in controller.userSubscriptionList) {
      if (subscription.status?.toLowerCase() == 'active') {
        activeSubscriptions++;
        currentPlan = subscription.subscriptionPlanName ?? "Unknown";
      }

      // Check for PENDING status to calculate days remaining
      if (subscription.status?.toUpperCase() == 'PENDING') {
        if (subscription.endDate != null) {
          // For each PENDING subscription, check if it has the latest end date
          if (latestEndDate == null ||
              subscription.endDate!.isAfter(latestEndDate)) {
            latestEndDate = subscription.endDate;
          }
        }
      }

      if (subscription.amount != null) {
        totalSpent += subscription.amount!.round();
      }

      if (subscription.startDate != null && subscription.endDate != null) {
        totalDays +=
            subscription.endDate!.difference(subscription.startDate!).inDays;
      }
    }

    // Calculate days remaining for PENDING subscription
    if (latestEndDate != null) {
      daysRemaining = latestEndDate.difference(DateTime.now()).inDays;
      if (daysRemaining < 0) daysRemaining = 0;
    }

    return Row(
      children: [
        _buildStatCard(
          'Days Remaining',
          daysRemaining.toString(),
          Icons.timer,
          Colors.orange[600]!, // Changed to orange to indicate pending status
        ),
        _buildStatCard(
          'Total Spent',
          '${NumberFormat('#,###').format(totalSpent)} VND',
          Icons.payments,
          Colors.purple[600]!,
        ),
        _buildStatCard(
          'Total Subscriptions',
          controller.userSubscriptionList.length.toString(),
          Icons.history,
          Colors.blue[600]!,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Subscription overview with timeline
  // Widget _buildSubscriptionOverview() {
  //   // Find active subscription
  //   UserSubscriptionModel? activeSubscription;
  //   for (var subscription in controller.userSubscriptionList) {
  //     if (subscription.status?.toLowerCase() == 'active') {
  //       activeSubscription = subscription;
  //       break;
  //     }
  //   }

  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           Colors.green[50]!,
  //           Colors.green[100]!,
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.green.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Your Premium Status',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.green[800],
  //           ),
  //         ),
  //         const SizedBox(height: 24),

  //         // Timeline or current subscription info
  //         if (activeSubscription != null)
  //           _buildActiveSubscriptionInfo(activeSubscription)
  //         else
  //           _buildNoActiveSubscription(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActiveSubscriptionInfo(UserSubscriptionModel subscription) {
    // Calculate progress
    double progress = 0.0;
    int daysRemaining = 0;
    int totalDays = 0;

    if (subscription.startDate != null && subscription.endDate != null) {
      final now = DateTime.now();
      totalDays =
          subscription.endDate!.difference(subscription.startDate!).inDays;
      final elapsed = now.difference(subscription.startDate!).inDays;
      daysRemaining = subscription.endDate!.difference(now).inDays;

      if (daysRemaining < 0) daysRemaining = 0;
      if (totalDays > 0) {
        progress = elapsed / totalDays;
        if (progress > 1.0) progress = 1.0;
        if (progress < 0.0) progress = 0.0;
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getIconForPlanName(
                              subscription.subscriptionPlanName ?? ''),
                          color: Colors.green[700],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscription.subscriptionPlanName ?? 'Premium Plan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Active until ${_formatDateDetailed(subscription.endDate)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subscription Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '$daysRemaining days remaining',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDateDetailed(subscription.startDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatDateDetailed(subscription.endDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 32),

            // Subscription details
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                        'Amount',
                        '${_formatAmount(subscription.amount?.toDouble() ?? 0.0)} VND',
                        Icons.payments),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                        'Payment Date',
                        _formatDateDetailed(subscription.paymentDate),
                        Icons.date_range),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                        'Transaction No',
                        subscription.transactionNo ?? 'No information',
                        Icons.receipt_long),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                        'Bank Code',
                        subscription.bankCode ?? 'No information',
                        Icons.account_balance),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showSubscriptionDetailsDialog(subscription),
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Full Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green[700]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoActiveSubscription() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.card_membership_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Subscription',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Subscribe to a premium plan to unlock all features',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Section header with optional add button
  Widget _buildSectionHeader(String title, String subtitle, bool showAddButton,
      {VoidCallback? onAddPressed}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Empty state when no subscriptions exist
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.subscriptions_outlined,
                size: 80,
                color: Colors.green[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Subscription History",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Subscribe to a premium plan to unlock all features and enhance your pregnancy journey",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.subdirectory_arrow_left),
                label: const Text('Subscribe Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Subscriptions in a detailed table view
  Widget _buildSubscriptionTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Expanded(flex: 3, child: _buildTableHeader('Plan Name')),
                Expanded(flex: 2, child: _buildTableHeader('Status')),
                Expanded(flex: 2, child: _buildTableHeader('Amount')),
                Expanded(flex: 2, child: _buildTableHeader('Start Date')),
                Expanded(flex: 2, child: _buildTableHeader('End Date')),
                const SizedBox(width: 80),
              ],
            ),
          ),

          // Table rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.userSubscriptionList.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final subscription = controller.userSubscriptionList[index];
              return _buildSubscriptionRow(subscription);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildSubscriptionRow(UserSubscriptionModel subscription) {
    final isActive = subscription.status?.toLowerCase() == 'active';

    return InkWell(
      onTap: () => _showSubscriptionDetailsDialog(subscription),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: Colors.transparent,
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.green[300] : Colors.grey[300],
              ),
              child: Icon(
                isActive ? Icons.check : Icons.history,
                size: 12,
                color: Colors.white,
              ),
            ),

            // Plan name
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green[50] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconForPlanName(
                            subscription.subscriptionPlanName ?? ''),
                        color: isActive ? Colors.green[700] : Colors.grey[700],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subscription.subscriptionPlanName ?? 'Unknown Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Status
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  subscription.status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.green[700] : Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Amount
            Expanded(
              flex: 2,
              child: Text(
                '${_formatAmount(subscription.amount?.toDouble() ?? 0.0)} VND',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // Start date
            Expanded(
              flex: 2,
              child: Text(
                _formatDateDetailed(subscription.startDate),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // End date
            Expanded(
              flex: 2,
              child: Text(
                _formatDateDetailed(subscription.endDate),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // View details
            SizedBox(
              width: 80,
              child: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: Colors.blue[700],
                  size: 20,
                ),
                onPressed: () => _showSubscriptionDetailsDialog(subscription),
                tooltip: 'View Details',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Benefits section
  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Premium Benefits',
          'Advantages of maintaining an active subscription',
          false,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildBenefitCard(
              'Detailed Health Tracking',
              'Access advanced tracking features for your pregnancy health metrics',
              Colors.indigo[700]!,
              Icons.favorite,
            )),
            Expanded(
                child: _buildBenefitCard(
              'Expert Content',
              'Exclusive articles and videos from pregnancy experts',
              Colors.orange[700]!,
              Icons.menu_book,
            )),
            Expanded(
                child: _buildBenefitCard(
              'Community Features',
              'Create posts and engage more deeply with the community',
              Colors.purple[700]!,
              Icons.people,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitCard(
      String title, String description, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Subscription detail dialog
  void _showSubscriptionDetailsDialog(UserSubscriptionModel subscription) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 800,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForPlanName(
                          subscription.subscriptionPlanName ?? ''),
                      color: Colors.green[700],
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subscription Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        Text(
                          subscription.subscriptionPlanName ?? 'Unknown Plan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: subscription.status?.toLowerCase() == 'active'
                          ? Colors.green[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      subscription.status ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: subscription.status?.toLowerCase() == 'active'
                            ? Colors.green[800]
                            : Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Content in a grid layout
              Wrap(
                spacing: 24,
                runSpacing: 24,
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

  String _formatDateDetailed(DateTime? date) {
    if (date == null) return 'No information';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
