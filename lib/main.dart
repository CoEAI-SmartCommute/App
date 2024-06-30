import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/Theme/theme.dart';
import 'package:smart_commute/providers/location_provider.dart';
import 'package:smart_commute/login/register.dart';
import 'package:smart_commute/firebase_options.dart';
import 'package:smart_commute/login/googlesignin.dart';
import 'package:smart_commute/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_commute/providers/shake_provider.dart';
import 'package:smart_commute/providers/theme_provider.dart';
import 'package:smart_commute/screens/home.dart';
import 'package:smart_commute/screens/permission.dart';
import 'package:smart_commute/services/foreground_service.dart';
import 'package:smart_commute/services/permissioncheck.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => GoogleSignInProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ShakeDetectorProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => LocationProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              themeMode: themeProvider.themeMode,
              theme: lightTheme,
              darkTheme: darkTheme,
              debugShowCheckedModeBanner: false,
              home: const MyHomePage(),
            );
          },
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late Future<Widget> _initialScreen;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    // ForegroundTaskInitializer.init();
    _initialScreen = _checkUserRegistered();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // App is in background
  //     ForegroundTaskInitializer.startForegroundTask();
  //   } else if (state == AppLifecycleState.resumed) {
  //     // App is in foreground
  //     ForegroundTaskInitializer.stopForegroundTask();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialScreen,
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong.'));
        } else {
          return snapshot.data ?? const LoginScreen();
        }
      },
    );
  }

  Future<Widget> _checkUserRegistered() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final uid = user.uid;
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (docSnapshot.exists) {
      final userData = docSnapshot.data() as Map<String, dynamic>;
      await _saveUserDataLocally(userData);
      bool isGranted = await checkPermissions();
      return isGranted ? const HomeScreen() : const PermissionScreen();
    } else {
      return const RegisterScreen();
    }
  }

  Future<void> _saveUserDataLocally(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', userData['fullName']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('phone', userData['phone']);
    await prefs.setString('dob', userData['dob']);
    await prefs.setString('gender', userData['gender']);
  }
}
