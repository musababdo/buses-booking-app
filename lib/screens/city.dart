
import 'dart:convert';

import 'package:busticket/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:busticket/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busticket/models/search.dart';

class City extends StatefulWidget {
  static String id='city';
  final List list;
  final int index;
  City({this.list,this.index});
  @override
  _DoctorSpecialityState createState() => _DoctorSpecialityState();
}

class _DoctorSpecialityState extends State<City> {

  String busname;

  List<Search> _list = [];
  List<Search> _search = [];
  var loading = false;

  Future getCity() async{
    setState(() {
      loading = true;
    });
    var url = Uri.parse('http://10.0.2.2/busticket/display_city.php');
    var response = await http.get(url);
    var data= json.decode(response.body);
    setState(() {
      for (Map i in data) {
        _list.add(Search.formJson(i));
        loading = false;
      }
    });
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _list.forEach((f) {
      if (f.city.contains(text) || f.id.toString().contains(text))
        _search.add(f);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    busname =  widget.list[widget.index]['name'];
    //print(city_id);
    getCity();
  }

  savePref(String cityname,String price) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("busname", busname);
      preferences.setString("cityname", cityname);
      preferences.setString("price", price);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: WillPopScope(
        onWillPop:(){
          //Navigator.popAndPushNamed(context, CartScreen.id);
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: blueColor,
            elevation: 0,
            title: Text(
              'الوجهه',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, Doctors.id);
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        controller: controller,
                        onChanged: onSearch,
                        decoration: InputDecoration(
                            hintText: "بحث عن ولايه",hintStyle: GoogleFonts.cairo(), border: InputBorder.none),),
                      trailing: IconButton(
                        onPressed: () {
                          controller.clear();
                          onSearch('');
                        },
                        icon: Icon(Icons.cancel),
                      ),
                    ),
                  ),
                ),
                loading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : Expanded(
                  child: _search.length != 0 || controller.text.isNotEmpty
                      ? ListView.builder(
                    itemCount: _search.length,
                    itemBuilder: (context, i) {
                      final b = _search[i];
                      List list = _search;
                      return Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseDoctor(list: list,index: i,),),);
                                        Navigator.pushNamed(context, Home.id);
                                        savePref(b.city,b.price);
                                      },
                                      child: Text(
                                        b.city,
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              )
                            ],
                          ));
                    },
                  )
                      : ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (context, i) {
                      final a = _list[i];
                      List list = _list;
                      return Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseDoctor(list: list,index: i,),),);
                                        Navigator.pushNamed(context, Home.id);
                                        savePref(a.city,a.price);
                                      },
                                      child: Text(
                                        a.city,
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              )
                            ],
                          ));
                    },
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
