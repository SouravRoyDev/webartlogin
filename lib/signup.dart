import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'otppage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}
class Person {
  final String email;

  Person(this.email);
}

class _SignupState extends State<Signup> {
  final _formKeysignup = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;
    });
  }
  TextEditingController _nameTextController = TextEditingController();

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Form(
          key: _formKeysignup,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Signup",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter email';
                //   }
                //   return null;
                // },
                controller: _nameTextController,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true, // Reduces height a bit
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius:
                          BorderRadius.circular(12), // Apply corner radius
                    ),
                    hintText: "Enter your name",
                    prefixIcon: Icon(Icons.person)),
              ),
           SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                controller: _emailTextController,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true, // Reduces height a bit
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius:
                          BorderRadius.circular(12), // Apply corner radius
                    ),
                    hintText: "email",
                    prefixIcon: Icon(Icons.email)),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLength: 6,
                // obscureText: true,
                validator: (password) {
                  if (isPasswordValid(password!))
                    return null;
                  else
                    return 'Enter a valid Password';
                },

                controller: _passwordTextController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscured,
                focusNode: textFieldFocusNode,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior
                      .never, //Hides label on focus or if filled
                  labelText: "Password",
                  filled: true,
                  isDense: true, // Reduces height a bit
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // No border
                    borderRadius:
                        BorderRadius.circular(12), // Apply corner radius
                  ),
                  prefixIcon: Icon(Icons.lock_rounded, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                    onPressed: () {
                      if (_formKeysignup.currentState!.validate())
                        _formKeysignup.currentState!.save();
                      SignupUser();
                      
                    },
                    child: Text("signup")),
              )
            ],
          ),
        ),
      ),
    );
  }

  void SignupUser() async {
    var url = "http://document.apibag.in:3001/v1/student";
    var body = {
      "name": _nameTextController.text,
      "emailId": _emailTextController.text,
      "password": _passwordTextController.text
    };
    var dataa = json.encode(body);
    var urlParse = Uri.parse(url);
    Response response = await http.post(urlParse,
        body: dataa, headers: {"Content-Type": "application/json"});
    var Dataa = jsonDecode(response.body);
    print(Dataa);
     if (Dataa["success"] == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OTPPage(title: _emailTextController.text,)));
    } else {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(Dataa["message"])));
    }
  }
}

bool isPasswordValid(String password) => password.length == 6;
