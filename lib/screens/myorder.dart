import 'dart:convert';
import 'package:busticket/screens/orderdetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:busticket/screens/home.dart';
import '../constants.dart';

class MyOrder extends StatefulWidget {
  static String id = 'myorder';
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

  final formatter = new NumberFormat("###,###");
  String id;

  Future cancelOrder(String id,String status) async{
    var url = Uri.parse('http://10.0.2.2/busticket/cancel_order.php');
    var response=await http.post(url, body: {
      "id"         : id,
      "status"     : status,
    });
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  SharedPreferences preferences;
  Future getOrder() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = Uri.parse('http://10.0.2.2/busticket/display_order.php');
    var response = await http.post(url, body: {
      "id": preferences.getString("id"),
    });
    var data = json.decode(response.body);

    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: blueColor,
          elevation: 0,
          title: Text(
            'حجوزاتي',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                color: Colors.white,
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
        body: FutureBuilder(
          future: getOrder(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            try {
              if(snapshot.data.length > 0 ){
                return snapshot.hasData ?
                ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      id = list[index]['id'];
                      //print(list);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            elevation: 8,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        list[index]['busname'],
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            color:Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '  : أسم البص',
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
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(list: list,index: index,),),);                                      },
                                        child: Text(
                                          'تفاصيل الحجز',
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              color:blueColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        list[index]['time'],
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            fontSize: 20,
                                            color:Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap:(){
                                      cancelDialog();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: blueColor,
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
                                              "الغاء الحجز",
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                  fontSize: 18,
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
                      );
                    })
                    : new Center(
                  child: new CircularProgressIndicator(),
                );
              }else{
                return Container(
                  height: screenHeight -
                      (screenHeight * .08) -
                      appBarHeight -
                      statusBarHeight,
                  child: Center(
                    child: Text('لايوجد طلبات',
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  ),
                );
              }
            }catch(e){
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
  cancelDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("تنبيه",style: GoogleFonts.cairo(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),),
            content: Text('هل تود الغاء طلبا نهائيا ',style: GoogleFonts.cairo(
              textStyle: TextStyle(
                fontSize: 18,
              ),
            ),),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("لا",style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),)
              ),
              FlatButton(
                  onPressed: (){
                    cancelOrder(id, "1");
                    Fluttertoast.showToast(
                        msg: "تم الغاء الحجز",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    Navigator.of(context).pop();
                    //Navigator.pushNamed(context, Home.id);
                  },
                  child: Text("نعم",style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),)
              ),
            ],
          );
        }
    );
  }
}