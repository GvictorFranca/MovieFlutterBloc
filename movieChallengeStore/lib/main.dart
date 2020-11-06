import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:movieChallengeStore/application/bindings/application_bindings.dart';
import 'package:movieChallengeStore/home/home_bindings.dart';
import 'package:movieChallengeStore/home/view/home_page.dart';


void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialBinding: ApplicationBindings(),
        theme: ThemeData(
            primaryColor: Colors.orangeAccent, primarySwatch: Colors.orange),
            getPages: [
              GetPage(
                name: '/',
                binding: HomeBindings(),
                page: () => HomePage(Get.find())
              )
            ],    
    );
  }
}

