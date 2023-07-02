import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskscheduler/UI/home_screen.dart';
import 'package:taskscheduler/constants/app_colors.dart';
import 'package:taskscheduler/constants/app_constants.dart';
import 'package:taskscheduler/state_management/date_selector_provider.dart';
import 'package:taskscheduler/state_management/login_details_provider.dart';
import 'package:taskscheduler/utils/app_utils.dart';
import 'package:taskscheduler/widgets/add_task_button.dart';
import 'package:taskscheduler/widgets/custom_text_field.dart';
import 'package:taskscheduler/widgets/date_picker.dart';

class CreateTaskScreen extends StatefulWidget {
  final fireUser;
  final title;
  final desc;
  final fireUid;
  final date;

  const CreateTaskScreen(
      {Key? key, this.fireUser, this.title, this.date, this.desc, this.fireUid})
      : super(key: key);

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  DateTime today = DateTime.now();
  String? fUid;

  String titleName = "";

  @override
  void initState() {
    editTask();
    // TODO: implement initState
    super.initState();
  }

  editTask() {
    if (widget.fireUser != null) {
      DateSelector dateSelector = Provider.of(context, listen: false);
        setState(() {
          taskName.text = widget.title;
          taskDescription.text = widget.desc;
          fUid = widget.fireUid;
          dateSelector.eventDate = DateTime.parse(widget.date);
          titleName = Constants.updateTask;
        });

    }
    else{
      setState(() {
        titleName = Constants.addNewTask;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.purpleBackground,
        elevation: 0,
        title: Text(titleName,
            style: const TextStyle(color: AppColors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          widget.fireUid != null
              ? IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.fireUid.toString())
                        .delete();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_forever))
              : Container()
        ],
      ),
      body: Container(
        height: screenHeight(context),
        width: screenWidth(context),
        decoration: const BoxDecoration(
          color: AppColors.purpleBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight(context) * 0.15,
              child: const CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.white,
                  child: Icon(Icons.create_outlined,
                      color: AppColors.purpleBackground)),
            ),
            Container(
              height: screenHeight(context) * 0.3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(
                    controller: taskName,
                    hintText: "Task Name",
                    label: "Task Name",
                    textAlign: TextAlign.left,
                    textInputType: TextInputType.multiline,
                    icon: const Icon(
                      Icons.task,
                      color: AppColors.white,
                    ),
                  ),
                  CustomTextField(
                    controller: taskDescription,
                    hintText: "Description",
                    label: "Description",
                    textAlign: TextAlign.left,
                    textInputType: TextInputType.multiline,
                    icon: const Icon(
                      Icons.description_outlined,
                      color: AppColors.white,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColors.white))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<DateSelector>(builder: (context, val, _) {
                            return Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "${(val.eventDate.day).toString().padLeft(2, '0')}-${val.eventDate.month.toString().padLeft(2, '0')}-${val.eventDate.year.toString()}",
                                style: const TextStyle(color: AppColors.white),
                              ),
                            );
                          }),
                          IconButton(
                              icon: const Icon(Icons.calendar_month_rounded,
                                  color: AppColors.white),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                pickDate(
                                  context,
                                );
                              }),
                        ],
                      ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight(context) * 0.08),
              child: AddTaskButton(
                title: widget.fireUser != null ? 'Update Task' : 'Add Task',
                onTap: () async {
                  LoginDetailsProvider userDetails =
                      Provider.of(context, listen: false);
                  DateSelector dateSelector =
                      Provider.of(context, listen: false);
                  if (fUid != null) {
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.fireUid.toString())
                        .set({
                      'uid': userDetails.loginDetails!.user!.uid,
                      'username':
                          '${userDetails.loginDetails!.user!.displayName}',
                      'taskdate': '${dateSelector.eventDate}',
                      'tasktitle': taskName.text,
                      'taskdesc': taskDescription.text,
                    }, SetOptions(merge: true));
                  } else {
                    FirebaseFirestore.instance.collection('user').add({
                      'uid': userDetails.loginDetails!.user!.uid,
                      'username':
                          '${userDetails.loginDetails!.user!.displayName}',
                      // 'taskdate': '${dateSelector.eventDate.day}-${dateSelector.eventDate.month}-${dateSelector.eventDate.year}',
                      'taskdate': '${dateSelector.eventDate}',
                      'tasktitle': taskName.text,
                      'taskdesc': taskDescription.text
                    });
                  }
                  taskDescription.clear();
                  taskName.clear();
                  await dateSelector.selectDate(today);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
