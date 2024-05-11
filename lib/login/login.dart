import 'package:flutter/material.dart';
import 'package:smart_commute/login/googlesignin.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Hey there \nWelcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: 50,
                child: SignInButton(
                  buttonType: ButtonType.google,
                  buttonSize: ButtonSize.medium,
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        });
                    final provider = Provider.of<GoogleSignInProvider>(
                      context,
                      listen: false,
                    );
                    await provider.googleLogin();

                    Navigator.of(context).pop();
                   
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
