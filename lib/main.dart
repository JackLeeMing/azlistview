import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/index.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AzListView Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AzListView',
          ),
        ),
        body: ListPage([
          PageInfo("GitHub Languages", (ctx) => GitHubLanguagePage(), false),
          PageInfo("Contacts", (ctx) => ContactsPage(), false),
          PageInfo("Contacts List", (ctx) => ContactListPage()),
          PageInfo("City List", (ctx) => CityListPage(), false),
          PageInfo(
              "City List(Custom header)", (ctx) => CityListCustomHeaderPage()),
          PageInfo("Car models", (ctx) => CarModelsPage(), false),
          PageInfo("10000 data", (ctx) => LargeDataPage(), false),
        ]),
      ),
    );
  }
}
