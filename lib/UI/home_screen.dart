import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskscheduler/UI/create_task.dart';
import 'package:taskscheduler/constants/app_colors.dart';
import 'package:taskscheduler/state_management/login_details_provider.dart';
import 'package:taskscheduler/utils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
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
      appBar: PreferredSize(
        preferredSize: Size(screenWidth(context), screenHeight(context) * 0.25),
        child: Consumer<LoginDetailsProvider>(
          builder: (context, val, _) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: NetworkImage(
                          "${val.loginDetails!.additionalUserInfo!
                              .profile!["picture"]}"))),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.white),
        height: screenHeight(context) * 0.7,
        width: screenWidth(context),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('user').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemBuilder: (context, item) {
                  LoginDetailsProvider loginDetailsProvider = Provider.of(context,listen: false);
                  String user = snapshot.data!.docs[item]['uid'];
                  String loginUser = loginDetailsProvider.loginDetails!.user!.uid;
                  return InkWell(
                    onTap: (){
                      if(user == loginUser){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTaskScreen(
                          fireUser: snapshot.data!.docs[item],
                          title: snapshot.data!.docs[item]['tasktitle'],
                          desc: snapshot.data!.docs[item]['taskdesc'],
                          fireUid: snapshot.data!.docs[item].reference.id,
                          date : snapshot.data!.docs[item]['taskdate']
                        )));
                      }
                      else{
                        displayToast("This task is not belongs to you");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: user == loginUser ? Colors.deepPurple.shade100: AppColors.white
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          Container(
                            width: screenWidth(context) * 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: screenWidth(context) * 0.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 5),
                                        child:  Text(
                                          "${snapshot.data!.docs[item]['tasktitle']}",
                                          style: const TextStyle(
                                              color: AppColors.titleBlack,
                                              fontWeight: FontWeight.bold),
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
                                Text(snapshot.data!.docs[item]['taskdate'].toString().substring(0,11),
                                  style: const TextStyle(color: AppColors.descBlack),),
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
    );
  }
}
