import 'package:flutter/material.dart';
import 'package:sokomoja_project/Controllers/auth_controller.dart';
import 'package:sokomoja_project/Utils/show_snackbar.dart';
import 'package:sokomoja_project/Views/Customer/auth/register_screen.dart';
import 'package:sokomoja_project/Views/Customer/landing/landing_screen.dart';

import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authcontroller = AuthController();
  late String email;

  late String password;

  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authcontroller.loginUsers(email, password);
      if (res == 'success') {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext) {
          return MainScreen();
        }));
      } else if (res != 'success') {
        setState(() {
          _isLoading = false;
          _formKey.currentState!.reset();
          showSnack(context, 'invalid account');
        });
      }

      // _authcontroller.whenComplete(() {
      //   setState(() {
      //     _formKey.currentState!.reset();
      //     //stop loading after creating account
      //     _isLoading = false;
      //   });
      // });
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'please fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Customer Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'email required!';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'password required!';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //loginbutton
              InkWell(
                onTap: () {
                  _loginUsers();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return MainLandingScreen();
                      })));
                    },
                    icon: Icon(Icons.home),
                  ),
                  Text('Not Registered?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CustomerRegisterScreen();
                      }));
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
