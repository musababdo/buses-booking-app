
import 'dart:convert';
import 'package:busticket/constants.dart';
import 'package:busticket/screens//home.dart';
import 'package:busticket/screens/city.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Bus extends StatefulWidget {
  static String id='bus';
  @override
  _BusState createState() => _BusState();
}

class _BusState extends State<Bus> {

  Future getBus() async{
    var url = Uri.parse('http://10.0.2.2/busticket/display_bus.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBus();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop:(){
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: blueColor,
            title: Text(
              'البصات',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    //color: Colors.black
                ),
              ),
            ),
          ),
          body:FutureBuilder(
            future: getBus(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              try {
                if(snapshot.data.length > 0 ){
                  return snapshot.hasData ?
                  ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List list = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: screenHeight * .18,
                            child: GestureDetector(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => City(list: list,index: index,),),);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                elevation: 8,
                                child:Row(
                                  //mainAxisAlignment:MainAxisAlignment.start ,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        bottomLeft: const Radius.circular(20),
                                      ),
                                      child:Image.network(list[index]['image'],
                                        height: MediaQuery.of(context).size.height * 0.4,
                                        fit: BoxFit.contain,),
                                    ),
                                    Padding(padding: const EdgeInsets.only(left:10)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        list[index]['name'],
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black
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
                      child: Text('لايوجد',
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            fontSize: 30,
                          ),
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
      ),
    );
  }
}
