import 'dart:convert';

import 'package:busticket/models/search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyDialog extends StatefulWidget {

  String price;

  MyDialog({Key key, this.mlocation,this.price}) : super(key: key);
  TextEditingController mlocation=new TextEditingController();

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  TextEditingController controller=new TextEditingController();

  //final location=["بورتسودان", "الخرطوم", "كسلا", "عطبره", "الابيض", "مدني", "القضارف", "حلفا", "الشماليه", "الجنينه", "ابو حمد"];

  //var items = List<String>();
  var loading = false;

  List<Search> _list = [];
  List<Search> _search = [];

  Future getBus() async{
    setState(() {
      loading = true;
    });
    var url = Uri.parse('http://10.0.2.2/busticket/display_city.php');
    var response = await http.get(url);
    var data = json.decode(response.body);
    setState(() {
      for (Map i in data) {
        _list.add(Search.formJson(i));
        loading = false;
      }
    });
    //return data;
  }

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

//  savePrice(String price) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    setState(() {
//      preferences.setString("price", price);
//      preferences.commit();
//    });
//  }

  @override
  void initState() {
    // TODO: implement initState
    //items.addAll(location);
    getBus();
    super.initState();
  }

//  void filterSearchResults(String query) {
//    List<String> dummySearchList = List<String>();
//    dummySearchList.addAll(location);
//    if(query.isNotEmpty) {
//      List<String> dummyListData = List<String>();
//      dummySearchList.forEach((item) {
//        if(item.contains(query)) {
//          dummyListData.add(item);
//        }
//      });
//      setState(() {
//        items.clear();
//        items.addAll(dummyListData);
//      });
//      return;
//    } else {
//      setState(() {
//        items.clear();
//        items.addAll(location);
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
              shrinkWrap: true,
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
                                  widget.mlocation.text=b.city;
                                  widget.price = b.price;
                                  Fluttertoast.showToast(
                                      msg: widget.price,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  //savePrice(b.price);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  b.city,
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                        fontSize: 18,
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
              shrinkWrap: true,
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
                                  widget.mlocation.text=a.city;
                                  widget.price = a.price;
                                  Fluttertoast.showToast(
                                      msg: widget.price,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  //savePrice(a.price);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  a.city,
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                        fontSize: 18,
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
    );
  }
}