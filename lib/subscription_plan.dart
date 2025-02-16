// import 'package:flutter/material.dart';

// import 'util/app_export.dart';

// class SubscriptionPlansScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Subscription Plans'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SubscriptionPlanCard(
//               title: 'Standard',
//               price: '\$15',
//               details: '\$20 USD if billed monthly\n1 License Minimum',
//               features: [
//                 'Unlimited calling',
//                 'Unlimited SMS & MMS',
//                 'Call controls',
//                 'Custom voicemail greeting',
//                 'Voicemail transcription',
//                 'G Suite & Office 365 integrations',
//                 'Fax (add-on)',
//                 'Custom off-hours routing',
//               ],
//               buttonText: 'Try free',
//             ),
//             SubscriptionPlanCard(
//               title: 'Pro',
//               price: '\$25',
//               details: '\$30 USD if billed monthly\n3 Licenses Minimum',
//               features: [
//                 'All Standard plan features, plus:',
//                 'Local number support in 50+ countries',
//                 'CRM integrations',
//                 '24/7 phone support',
//                 'Unlimited meetings',
//                 '5 hour meeting duration',
//                 'API & webhooks',
//                 '10 offices',
//                 '25 ring groups',
//                 'Hold queues',
//                 'International SMS',
//                 'Zapier, Zendesk, Slack integrations',
//                 'Deskphone support',
//               ],
//               buttonText: 'Try free',
//               isPopular: true,
//             ),
//             SubscriptionPlanCard(
//               title: 'Enterprise',
//               price: 'Contact us',
//               details: '100 License Minimum',
//               features: [
//                 'All Pro plan features, plus:',
//                 '100% uptime Service Level Agreements (SLA)',
//                 'Extensions',
//                 'Unlimited office locations',
//                 'Enhanced 24/7 Phone Support',
//                 'Unlimited ring groups',
//                 'Azure Integration',
//                 'IAM/SSO Integrations',
//                 'Retention policies',
//               ],
//               buttonText: 'Get a Quote',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SubscriptionPlanCard extends StatelessWidget {
//   final String title;
//   final String price;
//   final String details;
//   final List<String> features;
//   final String buttonText;
//   final bool isPopular;

//   SubscriptionPlanCard({
//     required this.title,
//     required this.price,
//     required this.details,
//     required this.features,
//     required this.buttonText,
//     this.isPopular = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Card(
//         elevation: 4,
//         margin: EdgeInsets.symmetric(horizontal: 8),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (isPopular)
//                 Center(
//                   child: Text(
//                     'MOST POPULAR!',
//                     style: TextStyle(
//                       color: Colors.purple,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               Center(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   price,
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.lightBlue,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   details,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               ...features.map((feature) => ListTile(
//                     leading: Icon(Icons.check, color: Colors.lightBlue),
//                     title: Text(feature),
//                   )),
//               SizedBox(height: 10),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Get.toNamed('/pregnancyprofile', preventDuplicates: false);
//                   },
//                   child: Text(buttonText),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
