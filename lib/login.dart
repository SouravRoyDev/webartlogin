import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:webartlogin/dashbord.dart';

import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailTextController = TextEditingController();

  TextEditingController _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (email) {
                  if (isEmailValid(email))
                    return null;
                  else
                    return 'Enter a valid email address';
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
                    return "";
                  else
                    return 'Enter Password';
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
            
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate())
                        _formKey.currentState!.save();

                      LoginUser();
                    },
                    child: const Text("Login")),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: "Click here to "),
                    TextSpan(
                        text: "Signup", style: TextStyle(color: Colors.blue))
                  ])),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void LoginUser() async {
    var url = "http://document.apibag.in:3001/v1/student/login";
    var body = {
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
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(Dataa["message"])));
    }
  }

  bool isPasswordValid(String password) => password.length == 6;
  bool isEmailValid(String? email) {
    Pattern? pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email!);
  }
}
