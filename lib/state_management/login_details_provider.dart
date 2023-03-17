import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginDetailsProvider with ChangeNotifier {
  UserCredential? loginDetails;

  userDetails(userDetails) {
    loginDetails = userDetails;
    notifyListeners();
  }

}
