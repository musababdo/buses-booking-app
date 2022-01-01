
import 'package:busticket/profile/profilescreen.dart';
import 'package:busticket/screens/bus.dart';
import 'package:busticket/screens/city.dart';
import 'package:busticket/screens/home.dart';
import 'package:busticket/screens/login.dart';
import 'package:busticket/screens/myorder.dart';
import 'package:busticket/screens/orderdetails.dart';
import 'package:busticket/screens/register.dart';
import 'package:busticket/screens/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Login.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          Login.id: (context) => Login(),
          Register.id: (context) => Register(),
          Home.id: (context) => Home(),
          Bus.id: (context) => Bus(),
          City.id: (context) => City(),
          ProfileScreen.id: (context) => ProfileScreen(),
          MyOrder.id: (context) => MyOrder(),
          OrderDetails.id: (context) => OrderDetails(),
        },
      );
  }
}
