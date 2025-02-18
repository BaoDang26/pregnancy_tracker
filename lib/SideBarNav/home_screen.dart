import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/subscription_plan.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/widgets/custom_card_subscription_plan_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../login/login_screen.dart';
import '../widgets/custom_card_blog_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselController _carouselController = CarouselController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header lớn
            // Container(
            //   padding: EdgeInsets.all(16.0),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Home Page',
            //     style: TextStyle(
            //       fontSize: 48, // Kích thước chữ lớn
            //       fontWeight: FontWeight.bold,
            //     ),a
            //   ),
            // ),
            Container(
              color: Color.fromARGB(255, 117, 196, 149),
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
            Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 500.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                  ),
                  items: [
                    'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
                    'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
                    'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
                    'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
                  ].map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      // Implement previous slide
                      _carouselController.previousPage();
                    },
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    onPressed: () {
                      // Implement next slide
                      _carouselController.nextPage();
                    },
                  ),
                ),
              ],
            ),
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
                                    Get.toNamed(AppRoutes.blogpostdetail);
                                    // Get.to(BlogDetailScreen());
                                  },
                                  commentCount: 2,
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
