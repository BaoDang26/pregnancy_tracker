import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/subscription_plan.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../widgets/custom_card_blog_widget.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
          TextButton(
            onPressed: () {
              // Navigate to register
            },
            child: Text('Register',
                style: TextStyle(color: Colors.black, fontSize: 20)),
          ),
          TextButton(
            onPressed: () {
              // Navigate to login
            },
            child: Text('Login',
                style: TextStyle(color: Colors.black, fontSize: 20)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.pink,
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Welcome to Your Pregnancy Journey',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Track, monitor, and celebrate every moment of your pregnancy',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
            Text(
              'Latest Blog Posts',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15.v),
                    // width: 1500,
                    height: 500,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio:
                            1.1, // Adjust the aspect ratio as needed
                      ),
                      // itemCount: controller.blogList.length,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // controller.goToBlogDetail(index);
                          },
                          child: AspectRatio(
                            aspectRatio:
                                1.0, // Adjust this ratio to fit the Container
                            child: Stack(
                              children: [
                                CustomBlogCard(
                                  photoUrl:
                                      'https://res.cloudinary.com/dlipvbdwi/image/upload/v1696896650/cld-sample.jpg',
                                  title: 'Blog title',
                                  // blog: controller.blogList[index],
                                  // photoUrl: controller.blogModel.value.blogPhoto,
                                  // title: controller.blogModel.value.blogName,
                                  onTitleTap: () {
                                    // Get.to(BlogDetailScreen());
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                        // return Obx(
                        //   () =>
                        // );
                      },
                    ),
                    // Obx(
                    //   () {
                    //     if (controller.isLoading.value) {
                    //       return const CircularProgressIndicator();
                    //     } else {
                    //       return RefreshIndicator(
                    //         onRefresh: () async {
                    //           await controller.refreshData();
                    //         }, // Define your refresh function
                    //         child:
                    //       );
                    //     }
                    //   },
                    // ),
                  ),
                ],
              ),
            ),
            Text(
              'Membership Packages',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15.v),
                    // width: 1500,
                    height: 500,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio:
                            1.1, // Adjust the aspect ratio as needed
                      ),
                      // itemCount: controller.blogList.length,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // controller.goToBlogDetail(index);
                          },
                          child: AspectRatio(
                            aspectRatio:
                                1.0, // Adjust this ratio to fit the Container
                            child: Stack(
                              children: [
                                SubscriptionPlanCard(
                                  title: 'Pro',
                                  price: '\$25',
                                  details:
                                      '\$30 USD if billed monthly\n3 Licenses Minimum',
                                  features: [
                                    'All Standard plan features, plus:',
                                    'CRM integrations',
                                    'Unlimited meetings',
                                    'Hold queues',
                                    'Zapier, Zendesk, Slack integrations',
                                  ],
                                  buttonText: 'Subscribe',
                                )
                              ],
                            ),
                          ),
                        );
                        // return Obx(
                        //   () =>
                        // );
                      },
                    ),
                    // Obx(
                    //   () {
                    //     if (controller.isLoading.value) {
                    //       return const CircularProgressIndicator();
                    //     } else {
                    //       return RefreshIndicator(
                    //         onRefresh: () async {
                    //           await controller.refreshData();
                    //         }, // Define your refresh function
                    //         child:
                    //       );
                    //     }
                    //   },
                    // ),
                  ),
                ],
              ),
            ),
            // Add your membership packages here
            // ...
            Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Column(
              children: [
                ExpansionTile(
                  title: Text(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      'What is the best time to start tracking my pregnancy?'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          style: TextStyle(fontSize: 17),
                          'It is best to start tracking your pregnancy as soon as you find out you are pregnant. This helps in monitoring your health and the baby development.',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      'How often should I visit my doctor during pregnancy?'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          style: TextStyle(fontSize: 17),
                          'It is best to start tracking your pregnancy as soon as you find out you are pregnant. This helps in monitoring your health and the baby development.',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
                // Add more ExpansionTile widgets for additional FAQs
              ],
            ),
          ],
        ),
      ),
    );
  }
}
