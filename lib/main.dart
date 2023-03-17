import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:taskscheduler/UI/home_screen.dart';
import 'package:taskscheduler/google_signin/google_signin.dart';
import 'package:taskscheduler/state_management/date_selector_provider.dart';
import 'package:taskscheduler/state_management/login_details_provider.dart';
import 'package:taskscheduler/utils/app_utils.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginDetailsProvider()),
    ChangeNotifierProvider(create: (_) => DateSelector())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: screenWidth(context) * 0.9,
          height: screenHeight(context) * 0.05,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: SignInButton(
            Buttons.Google,
            padding: const EdgeInsets.all(10),
            onPressed: sigIn,
          ),
        ),
      ),
    );
  }

  sigIn() async {
    LoginDetailsProvider loginProvider = Provider.of(context, listen: false);
    UserCredential loginCredential = await signInWithGoogle();
    if (loginCredential.credential!.token != null) {
      print(loginCredential.credential);
      print(loginCredential.additionalUserInfo);
      print(loginCredential.user);
      await loginProvider.userDetails(loginCredential);
      if(loginProvider.loginDetails != null){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()), (
                route) => false);
      }

    } else {
      print("something went wrong with google sigin =====>");
    }
  }
}
