import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:taskscheduler/UI/create_task.dart';
import 'package:taskscheduler/constants/app_colors.dart';
import 'package:taskscheduler/main.dart';
import 'package:taskscheduler/state_management/login_details_provider.dart';
import 'package:taskscheduler/utils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  signOutGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      showLoading(context);
      await _googleSignIn.signOut();
      if (context.mounted) {
        Navigator.of(context).pop(); // Error on this line
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
      print("User signed out");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: signOutGoogle,
              icon: const Icon(
                Icons.login_outlined,
                color: Colors.white,
              ))
        ],
        backgroundColor: AppColors.purpleBackground,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Home Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
          backgroundColor: AppColors.purpleBackground,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateTaskScreen()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: AppColors.white),
          // height: screenHeight(context) * 0.7,
          width: screenWidth(context),
          child: Column(
            children: [
              Consumer<LoginDetailsProvider>(builder: (context, val, _) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        minRadius: 35,
                        maxRadius: 45,
                        backgroundImage: NetworkImage(
                            "${val.loginDetails!.additionalUserInfo!.profile!["picture"]}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${val.loginDetails!.additionalUserInfo!.profile!["name"]}"
                              .toString()
                              .toUpperCase(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                );
              }),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "TO-DO-LIST",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                     else if (snapshot.data!.size == 0) {
                        return Padding(
                          padding:  EdgeInsets.only(top: screenHeight(context) * 0.15),
                          child: const Text(
                            "No List Found",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, item) {
                          LoginDetailsProvider loginDetailsProvider =
                              Provider.of(context, listen: false);
                          String user = snapshot.data!.docs[item]['uid'];
                          String loginUser =
                              loginDetailsProvider.loginDetails!.user!.uid;
                          return InkWell(
                            onTap: () {
                              if (user == loginUser) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateTaskScreen(
                                            fireUser: snapshot.data!.docs[item],
                                            title: snapshot.data!.docs[item]
                                                ['tasktitle'],
                                            desc: snapshot.data!.docs[item]
                                                ['taskdesc'],
                                            fireUid: snapshot
                                                .data!.docs[item].reference.id,
                                            date: snapshot.data!.docs[item]
                                                ['taskdate'])));
                              } else {
                                displayToast("This task is not belongs to you");
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: user == loginUser
                                      ? Colors.black12
                                      : AppColors.white),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.black12,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.purpleBackground,
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: screenWidth(context) * 0.5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                  "${snapshot.data!.docs[item]['tasktitle']}",
                                                  style: const TextStyle(
                                                      color:
                                                          AppColors.titleBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                "${snapshot.data!.docs[item]['taskdesc']}",
                                                style: const TextStyle(
                                                  color: AppColors.descBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.docs[item]['taskdate']
                                              .toString()
                                              .substring(0, 11),
                                          style: const TextStyle(
                                              color: AppColors.descBlack),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
