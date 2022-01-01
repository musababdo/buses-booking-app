
import 'dart:convert';

import 'package:busticket/constants.dart';
import 'package:busticket/customTextView.dart';
import 'package:busticket/profile/profilescreen.dart';
import 'package:busticket/screens/bus.dart';
import 'package:busticket/screens/myorder.dart';
import 'package:busticket/searchDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Info {
  //Constructor
  String username;
  String phone;

  Info.fromJson(Map json) {
    username = json['username'];
    phone    = json['phone'];
  }
}

class Home extends StatefulWidget {
  static String id='home';
  final List list;
  final int index;
  Home({this.list,this.index});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _bottomBarIndex = 0;
  String id,price,busname,cityname;
  bool showPrice = false;

  DateTime currentdate=new DateTime.now();
  String formatdate;
  final formatter = new NumberFormat("###,###");

  TextEditingController username = new TextEditingController();
  TextEditingController phone    = new TextEditingController();
  TextEditingController location = new TextEditingController();
  TextEditingController seat     = new TextEditingController();

  Future getMyId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id") ;
    });
  }

  Future getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      busname = preferences.getString("busname") ;
      cityname = preferences.getString("cityname") ;
      price = preferences.getString("price") ;
    });
  }



  Future orderNow() async{
    var url = Uri.parse('http://10.0.2.2/busticket/save_order.php');
    var response=await http.post(url, body: {
      "name"     : username.text,
      "phone"    : phone.text,
      "tocity"   : cityname,
      "location" : location.text,
      "busname"  : busname,
      "seat"     : seat.text,
      "time"     : formatdate,
      "id"       : id
    });
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  SharedPreferences preferences;
  Future getProfile() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("phone"));
    });
    var url = Uri.parse('http://10.0.2.2/busticket/profile/display_profile.php');
    var response = await http.post(url, body: {
      "id" : preferences.getString("id"),
    });
    var data = json.decode(response.body);
    setState(() {
      final items = (data['login'] as List).map((i) => new Info.fromJson(i));
      for (final item in items) {
        username.text = item.username;
        phone.text    = item.phone;
      }
      //print(_username);
    });

    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    getMyId();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    formatdate=new DateFormat('yyyy.MMMMM.dd hh:mm:ss aaa').format(currentdate);
    return Form(
      key: _globalKey,
      child: SafeArea(
        child: WillPopScope(
          onWillPop:(){
            exitDialog();
            return Future.value(false);
          },
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _bottomBarIndex,
              fixedColor: blueColor,
              onTap: (value) {
                setState(() {
                  _bottomBarIndex = value;
                });
                switch(value){
                  case 0:
                    Navigator.pushNamed(context, MyOrder.id);
                    break;
                  case 1:
                    Navigator.pushNamed(context, ProfileScreen.id);
                    break;
                }
              },
              items: [
                BottomNavigationBarItem(
                    title: Text('حجوزاتي',style: GoogleFonts.cairo(textStyle: TextStyle(fontSize: 16,)),), icon: Icon(Icons.date_range)),
                BottomNavigationBarItem(
                    title: Text('الشخصيه',style: GoogleFonts.cairo(textStyle: TextStyle(fontSize: 16,)),), icon: Icon(Icons.person)),
              ],
            ),
            appBar: AppBar(
              backgroundColor: blueColor,
              title: Text(
                'الرئيسيه',
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                    //color: Colors.black
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,top: 80),
              child: ListView(
                children: <Widget>[
                  Spacer(
                    flex: 3,
                  ),
                  Center(
                    child: Text(
                        'الرجاء ملء بياناتك وتكمله الحجز',
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: username,
                    onClick: (value) {
                      username = value;
                    },
                    hint: 'أسم المستخدم',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: phone,
                    onClick: (value) {
                      phone = value;
                    },
                    hint: 'رقم الهاتف',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: location,
                    onClick: (value) {
                      location = value;
                    },
                    hint: 'عنوان السكن',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: seat,
                    onClick: (value) {
                      seat = value;
                    },
                    hint: 'المقاعد',
                    icon: Icons.event_seat,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'SDG ${price} : سعر التذكره ',
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap:(){
                      if(username.text.isEmpty && phone.text.isEmpty&& location.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "الرجاء ملء بياناتك",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        orderNow();
                        Fluttertoast.showToast(
                            msg: "تم أرسال البيانات بنجاح",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        location.text='';
                        seat.text='';
                        //Navigator.pushNamed(context, Bus.id);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF1C1C1C),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: blueColor.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child:  Center(
                          child: Text(
                              "أرسال",
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  exitDialog(){
    showModalBottomSheet(context: context, builder: (context){
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text("الخروج من التطبيق",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('هل تود الخروج من التطبيق ',style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 19,
                      ),
                    ),),
                    const SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('الغاء',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                SystemNavigator.pop();
                              });
                            },
                            child: Text('موافق',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    });
  }
}
