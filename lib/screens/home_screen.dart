import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weight_tracker/screens/login_screen.dart';

import '../widgets/custom_text_field.dart';

final kweightRef = FirebaseFirestore.instance.collection("weights");

class HomeScreen extends StatelessWidget {
  final TextEditingController weightController = TextEditingController();

  deleteWeight(String id) async {
    await kweightRef.doc(id).delete();
  }

  updateWeight(String id) async {
    final double number = double.parse(weightController.text);
    await kweightRef.doc(id).update({
      "weight": number,
      "timestamp": DateTime.now().microsecondsSinceEpoch.toString(),
    });
  }

  addWeight(BuildContext context) async {
    try {
      final double number = double.parse(weightController.text);
      await kweightRef.add({
        "weight": number,
        "timestamp": DateTime.now().microsecondsSinceEpoch.toString(),
      });
      weightController.clear();
      Navigator.pop(context);
    } catch (e) {
      print("Exception");
      return;
    }
  }

  logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Weight Tracker"),
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              logOut(context);
            },
            icon: Icon(
              LineIcons.alternateSignOut,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: kweightRef.orderBy('timestamp').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> list = [];
          if (snapshot.hasData) {
            list = snapshot.data!.docs
                .map(
                  (e) => Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                deleteWeight(e.id);
                              },
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (_) {
                                _showCustomBottomSheet(
                                  context: context,
                                  onClicked: () {
                                    updateWeight(e.id);
                                    weightController.clear();
                                    Navigator.pop(context);
                                  },
                                  initialValue: e['weight'],
                                );
                              },
                              backgroundColor: Colors.yellow[800]!,
                              foregroundColor: Colors.white,
                              icon: LineIcons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          height: 100,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Weight : " + e['weight'].toString(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                )
                .toList();
          }

          return Column(
            children: list,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCustomBottomSheet(
            context: context,
            onClicked: () {
              addWeight(context);
            },
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(LineIcons.plus),
      ),
    );
  }

  _showCustomBottomSheet({required BuildContext context, required void Function() onClicked, double? initialValue}) {
    if (initialValue != null) {
      weightController.text = initialValue.toString();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(builder: (context, _) {
          return Container(
            height: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "Enter Weight",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextField(
                    controller: weightController,
                    hint: "Weight",
                    inputType: TextInputType.number,
                    icon: Icons.all_inbox_outlined,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                    ),
                    onPressed: onClicked,
                    child: Icon(
                      LineIcons.save,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
