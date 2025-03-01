import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'config/theme.dart';
import 'routes/app_routes.dart';
import 'util/initial_bindings.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      setUrlStrategy(PathUrlStrategy());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pregnancy Tracker',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.pages,
      // home: HomeScreen(),
    );
  }
}
