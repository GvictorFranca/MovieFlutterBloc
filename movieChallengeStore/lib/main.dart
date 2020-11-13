import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieChallengeStore/home/view/home_page.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Style;

import 'application/di/injection.dart';

void main() async {
  Injection.init();
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Style.Colors.mainColor, primarySwatch: Colors.grey),
      home: HomePage(),
      initialRoute: '/',
    );
  }
}
