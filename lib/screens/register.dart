
import 'dart:async';
import 'dart:convert';

import 'package:busticket/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Register extends StatefulWidget {
  static String id='register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _state=0;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phone    = new TextEditingController();

  Future register() async{
    var url = Uri.parse('http://10.0.2.2/busticket/register.php');
    var response=await http.post(url, body: {
      "username" : username.text.trim(),
      "password" : password.text.trim(),
      "phone"    : phone.text.trim(),
    });
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  bool _validate = false;
  bool _secureText = true;
  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String _errorMessage(String hint) {
    if(hint=="أسم المستخدم"){
      return 'الرجاء ادخال اسم المستخدم';
    }else if(hint=="رقم الهاتف"){
      return 'الرجاء ادخال رقم الهاتف';
    }else if(hint=="كلمه المرور"){
      return 'الرجاء ادخال كلمه المرور';
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: _globalKey,
      child: SafeArea(
        child: WillPopScope(
          onWillPop:(){
            Navigator.popAndPushNamed(context, Login.id);
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: blueColor,
              elevation: 0,
              title: Text(
                'انشاء حساب',
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .2,
                    ),
                    TextFormField(
                      validator:(value) {
                        if (value.isEmpty) {
                          return _errorMessage("أسم المستخدم");
                          // ignore: missing_return
                        }
                      },
                      controller: username,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person,color: blueColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "أسم المستخدم"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value.isEmpty) {
                          return _errorMessage("رقم الهاتف");
                          // ignore: missing_return
                        }
                      },
                      controller: phone,
                      keyboardType:TextInputType.phone,
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone,color: blueColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "رقم الهاتف"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value.isEmpty) {
                          return _errorMessage("كلمه المرور");
                          // ignore: missing_return
                        }
                      },
                      controller: password,
                      obscureText: _secureText,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock,color: blueColor,),
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "كلمه المرور"
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                      child: Builder(
                        builder: (context) => FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            if (_state == 0) {
                              animateButton();
                            }

                            if (_globalKey.currentState.validate()){
                              _globalKey.currentState.save();
                              try{
                                register();
                                Fluttertoast.showToast(
                                    msg: "تم الحفظ بنجاح",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: kMainColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                Navigator.popAndPushNamed(context, Login.id);
                              }on PlatformException catch(e){

                              }
                            }else{
                              setState(() {
                                _state = 0;
                              });
                            }
                          },
                          color: blueColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 5),
                            child: Center(
                                child:setUpButtonChild()
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, Login.id);
                          },
                          child: Text(
                            'تسجيل دخول   ',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: blueColor,
                                ),
                              ),
                          ),
                        ),
                        Text(
                          'لديك حساب ؟',
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "أنشاء الحساب",
        style: GoogleFonts.cairo(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 0;
      });
    });
  }
}
