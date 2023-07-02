import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:taskscheduler/UI/home_screen.dart';
import 'package:taskscheduler/constants/app_colors.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.purpleBackground,
        elevation: 1,
        title: const Text("Login Screen"),
        centerTitle: true,
      ),
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                "LOGIN TO MAKE TO-DO-LIST",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.purpleBackground),
              ),
            ),
            SignInButton(
              Buttons.Google,
              padding: const EdgeInsets.all(10),
              onPressed: sigIn,
              elevation: 10,
            ),
          ],
        ),
      ),
    );
  }

  sigIn() async {
    LoginDetailsProvider loginProvider = Provider.of(context, listen: false);
    UserCredential loginCredential = await signInWithGoogle();
    showLoading(context);
    if (loginCredential.credential!.token != null) {
      print(loginCredential.credential);
      print(loginCredential.additionalUserInfo);
      print(loginCredential.user);
      await loginProvider.userDetails(loginCredential);
      if (loginProvider.loginDetails != null) {
        if (context.mounted ) {
          Navigator.of(context).pop(); // Error on this line
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      }
    } else {
      if (context.mounted ) {
        Navigator.of(context).pop(); // Error on this line
      }
      print("something went wrong with google sigin =====>");
    }
  }
}
