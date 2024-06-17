import 'package:flutter/material.dart';
import 'package:smart_commute/login/googlesignin.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_commute/screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/LauncherIcon.png',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text('hello',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            Text('Saarthi is easy and safe to use.',
                style: GoogleFonts.lato(
                  fontSize: 18,
                )),
            const SizedBox(height: 50),
            SignInButton(
              buttonType: ButtonType.google,
              buttonSize: ButtonSize.large,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              btnText: 'Continue with Google',
              btnTextColor: Colors.grey,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(child: CircularProgressIndicator());
                    });
                final provider = Provider.of<GoogleSignInProvider>(
                  context,
                  listen: false,
                );
                await provider.googleLogin();
                if (!mounted) return;
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
