import 'package:cinema_aldo_test/view/feedPopular.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      title: 'Cinema_ALDO',
      home: const Center(
        child: FeedViewPopular(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
