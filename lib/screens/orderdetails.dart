import 'dart:convert';
import 'package:busticket/constants.dart';
import 'package:busticket/screens/myorder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  static String id='orderdetails';

  final List list;
  final int index;
  OrderDetails({this.list,this.index});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  String username,phone,location,busname,tocity,seat,time;
  var data,image;
  final formatter = new NumberFormat("###,###");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username  = widget.list[widget.index]['username'];
    phone     = widget.list[widget.index]['phone'];
    location  = widget.list[widget.index]['location'];
    busname   = widget.list[widget.index]['busname'];
    tocity    = widget.list[widget.index]['tocity'];
    seat      = widget.list[widget.index]['seat'];
    time      = widget.list[widget.index]['time'];
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

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
              'تفاصيل الحجز',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                  color:Colors.white,
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                //Navigator.pop(context);
                Navigator.popAndPushNamed(context, MyOrder.id);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      busname,
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color:Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      '  : أسم الص',
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize: 20,
                            color:Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      tocity,
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color:Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      '  :  الي',
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize: 20,
                            color:Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      seat,
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color:Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      '  : مقعد رقم',
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize: 20,
                            color:Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color:Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}