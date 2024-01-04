import 'package:flutter/material.dart';
import 'package:training_drift/route/route_generator.dart';
import 'package:training_drift/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    initialRoute: '/',
    onGenerateRoute: RouteGenerator.generateRoute,
    home: const HomeScreen(),
  ));
}
