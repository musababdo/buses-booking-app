
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busticket/constants.dart';
import 'package:busticket/profile/body.dart';

class ProfileScreen extends StatefulWidget {
  static String id='ProfileScreen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: blueColor,
            elevation: 0,
            title: Text(
              'الصفحه الشخصيه',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, Home.id);
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Body(),
        ),
      ),
    );
  }
}
