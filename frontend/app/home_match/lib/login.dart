import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isLoggingIn = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeMatch - Login'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextField(
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextField(
                          controller: _password,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/register/', (route) => false);
                            },
                            child:
                                const Text('Not Registered? Register Here! '),
                          ),
                        ),
                        FilledButton(
                          onPressed: _isLoggingIn
                              ? null
                              : () async {
                                  // Disable the button if _isLoggingIn is true
                                  setState(() {
                                    _isLoggingIn =
                                        true; // Set _isLoggingIn to true when login starts
                                  });

                                  final email = _email.text;
                                  final password = _password.text;

                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: email, password: password);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/homepage/', (_) => false);
                                  } on Exception catch (e) {
                                    print(e);
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isLoggingIn = false;
                                      });
                                    }
                                  }
                                },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        )
        // body:
        );
  }
}
