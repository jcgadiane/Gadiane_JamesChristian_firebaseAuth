import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../../service_locators.dart';

class AuthScreen extends StatefulWidget {
  static const String route = 'auth-screen';

  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCon = TextEditingController(),
      _passCon = TextEditingController(),
      _pass2Con = TextEditingController(),
      _usernameCon = TextEditingController();
  final AuthController _authController = locator<AuthController>();

  String prompts = '';

  @override
  void initState() {
    _authController.addListener(handleLogin);
    super.initState();
  }

  @override
  dispose() {
    _authController.removeListener(handleLogin);
    super.dispose();
  }

  @override
  handleLogin() {
    if (_authController.currentUser != null) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _authController,
        builder: (context, Widget? w) {
          ///shows a loading screen while initializing
          if (_authController.working) {
            return const Scaffold(
              body: Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Chat App'),
                  backgroundColor: const Color(0xFF303030),
                  centerTitle: true,
                ),
                backgroundColor: Colors.grey[400],
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 4 / 5,
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: MaterialButton(
                                        shape: const CircleBorder(
                                          side: BorderSide(
                                            width: 2,
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: const Text("Login"),
                                        color: Colors.grey,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          loginDialog();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: MaterialButton(
                                        shape: const CircleBorder(
                                          side: BorderSide(
                                            width: 2,
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: const Text("Register"),
                                        color: Colors.grey,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          registerDialog();
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          }
        });
  }

  loginDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Login'),
            content: Container(
              height: 250,
              width: 250,
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_authController.error?.message ?? ''),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            controller: _emailCon,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            controller: _passCon,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed:
                                (_formKey.currentState?.validate() ?? false)
                                    ? () {
                                        _authController.login(
                                          _emailCon.text.trim(),
                                          _passCon.text.trim(),
                                        );
                                      }
                                    : null,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                primary:
                                    (_formKey.currentState?.validate() ?? false)
                                        ? const Color(0xFF303030)
                                        : Colors.grey),
                            child: const Text('Log in'),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ));

  registerDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Register'),
            content: SingleChildScrollView(
              child: Container(
                width: 300,
                height: 350,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_authController.error?.message ?? ''),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            controller: _emailCon,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            controller: _passCon,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Confirm Password',
                            ),
                            controller: _pass2Con,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (_passCon.text != _pass2Con.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Enter username',
                            ),
                            controller: _usernameCon,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed:
                                (_formKey.currentState?.validate() ?? false)
                                    ? () {
                                        _authController.register(
                                            email: _emailCon.text.trim(),
                                            password: _passCon.text.trim(),
                                            username: _usernameCon.text.trim());
                                      }
                                    : null,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                primary:
                                    (_formKey.currentState?.validate() ?? false)
                                        ? const Color(0xFF303030)
                                        : Colors.grey),
                            child: const Text('Register'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
