import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFE5D1E8),
        actions: [],
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
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAD6E8C)),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStatCards(),
                const SizedBox(height: 24),
                _buildCharts(context),
                const SizedBox(height: 24),
                // _buildRecentActivity(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEBD7E6),
        borderRadius: BorderRadius.circular(10),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFBF8EB0).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Color(0xFF8E6C88),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF614051),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Welcome back, Admin! Here\'s what\'s happening in your app',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8E6C88),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'Key Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF614051),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Users',
                value: controller.dashboardTotalUser.value.totalUsers ?? 0,
                icon: Icons.people,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Premium Users',
                value: controller.dashboardTotalUser.value.premiumUsers ?? 0,
                icon: Icons.star,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Regular Users',
                value: controller.dashboardTotalUser.value.regularUsers ?? 0,
                icon: Icons.person,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Total User Subscriptions',
                value: controller.dashboardTotalUserSubscription.value
                        .totalSubscriptions ??
                    0,
                icon: Icons.card_membership,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF614051),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            // child: Text(
            //   'View Details',
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: color,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF614051),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildPieChart(),
            ),
            const SizedBox(width: 16),

            // Expanded(
            //   child: _buildBarChart(),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final premiumUsers = controller.dashboardTotalUser.value.premiumUsers ?? 0;
    final regularUsers = controller.dashboardTotalUser.value.regularUsers ?? 0;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
            'User Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF614051),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Premium vs Regular Users',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.amber,
                    value: premiumUsers.toDouble(),
                    title: 'Premium',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: regularUsers.toDouble(),
                    title: 'Regular',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Premium', Colors.amber),
              const SizedBox(width: 20),
              _buildLegendItem('Regular', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const Text(
      //       'Subscription Overview',
      //       style: TextStyle(
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //         color: Color(0xFF614051),
      //       ),
      //     ),
      //     const SizedBox(height: 8),
      //     Text(
      //       'Monthly subscription trends',
      //       style: TextStyle(
      //         fontSize: 12,
      //         color: Colors.grey[600],
      //       ),
      //     ),
      //     const SizedBox(height: 20),
      //     Expanded(
      //       child: BarChart(
      //         BarChartData(
      //           alignment: BarChartAlignment.spaceAround,
      //           maxY: 100,
      //           barTouchData: BarTouchData(enabled: false),
      //           titlesData: FlTitlesData(
      //             show: true,
      //             bottomTitles: AxisTitles(
      //               sideTitles: SideTitles(
      //                 showTitles: true,
      //                 getTitlesWidget: (value, meta) {
      //                   const titles = [
      //                     'Jan',
      //                     'Mar',
      //                     'May',
      //                     'Jul',
      //                     'Sep',
      //                     'Nov'
      //                   ];
      //                   final index = value.toInt();
      //                   if (index >= 0 && index < titles.length) {
      //                     return Text(
      //                       titles[index],
      //                       style: const TextStyle(fontSize: 10),
      //                     );
      //                   }
      //                   return const Text('');
      //                 },
      //               ),
      //             ),
      //             leftTitles: AxisTitles(
      //               sideTitles: SideTitles(
      //                 showTitles: true,
      //                 getTitlesWidget: (value, meta) {
      //                   if (value % 20 == 0) {
      //                     return Text(
      //                       value.toInt().toString(),
      //                       style: const TextStyle(fontSize: 10),
      //                     );
      //                   }
      //                   return const Text('');
      //                 },
      //               ),
      //             ),
      //             topTitles:
      //                 AxisTitles(sideTitles: SideTitles(showTitles: false)),
      //             rightTitles:
      //                 AxisTitles(sideTitles: SideTitles(showTitles: false)),
      //           ),
      //           gridData: FlGridData(
      //             show: true,
      //             horizontalInterval: 20,
      //             getDrawingHorizontalLine: (value) {
      //               return FlLine(
      //                 color: Colors.grey[200],
      //                 strokeWidth: 1,
      //               );
      //             },
      //           ),
      //           borderData: FlBorderData(show: false),
      //           barGroups: [
      //             _buildBarGroup(0, 30),
      //             _buildBarGroup(1, 45),
      //             _buildBarGroup(2, 55),
      //             _buildBarGroup(3, 70),
      //             _buildBarGroup(4, 85),
      //             _buildBarGroup(5, 65),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [Color(0xFFAD6E8C), Color(0xFF8E6C88)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.purple[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            icon: Icons.payment,
            title: 'New Subscription',
            description: 'John Doe subscribed to Premium Plan',
            time: '5 minutes ago',
            color: Colors.green,
          ),
          const Divider(),
          _buildActivityItem(
            icon: Icons.person_add,
            title: 'New User Registration',
            description: 'Sarah Smith created a new account',
            time: '30 minutes ago',
            color: Colors.blue,
          ),
          const Divider(),
          _buildActivityItem(
            icon: Icons.post_add,
            title: 'New Blog Post',
            description: 'A new blog post was created',
            time: '1 hour ago',
            color: Colors.orange,
          ),
          const Divider(),
          _buildActivityItem(
            icon: Icons.update,
            title: 'Subscription Expired',
            description: 'Mike Johnson\'s subscription expired',
            time: '3 hours ago',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF614051),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
