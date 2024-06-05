import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
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
          title: const Text('HomeMatch - Register'),
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
                        const SizedBox(height: 20),
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
                          decoration: const InputDecoration(labelText: "Password ", border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                            },
                            child: const Text('Already have an account? Login!'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: _isLoggingIn
                              ? null
                              : () async {
                                  final email = _email.text;
                                  final password = _password.text;
                                  setState(() {
                                    _isLoggingIn = true;
                                  });
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(email: email, password: password);
                                    Navigator.of(context).pushNamedAndRemoveUntil('/emailverify/', (_) => false);
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('The password provided is too weak.'),
                                        ),
                                      );
                                    } else if (e.code == 'email-already-in-use') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('The account already exists for that email.'),
                                        ),
                                      );
                                    } else if (e.code == 'invalid-email') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('The email address is invalid.'),
                                        ),
                                      );
                                    } else {
                                      if (kDebugMode) {
                                        print(e.code);
                                      }
                                    }
                                  }
                                },
                          child: const Text(
                            'Register',
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ));
    // body:);
  }
}
