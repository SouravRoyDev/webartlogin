import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webartlogin/login.dart';
import 'package:webartlogin/signup.dart';

import 'dashbord.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key, required this.title});
  final String title;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  
  

  
  TextEditingController _otpTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify otp"),
      ),
      body: Form(
        key: _formKey,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${widget.title}'),
            TextFormField(
              controller: _otpTextController,
              
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide.none, // No border
                    borderRadius:
                        BorderRadius.circular(12), // Apply corner radius
                  ),
                hintText: "Enter otp received on mail"),
            ),
            OutlinedButton(
                onPressed: () {
                  LoginUser();
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) {
                  //     return Login();
                  //   },
                  // ));
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
  

  void LoginUser() async {
    var url = "http://document.apibag.in:3001/v1/student/opt/verification";
    var body = {
      // "emailId": _emailTextController.text,
      // "password": _passwordTextController.text,
      "otp":_otpTextController.text
    };
    var dataa = json.encode(body);
    print(dataa);
    var urlParse = Uri.parse(url);
    print(urlParse);
    Response response = await http.patch(urlParse,
        body: dataa, headers: {"Content-Type": "application/json"});
        print(response);
    var Dataa = jsonDecode(response.body);
    
    print(Dataa);
    if (Dataa["message"] == 0) {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(Dataa["message"])));
    }
  }
}
