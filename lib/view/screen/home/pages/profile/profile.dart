import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:reefs_nav/view/screen/home/homepage.dart';
import 'package:reefs_nav/view/widget/navigation/nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  static const String profile = 'ProfileScreen';

  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      // Handle case when user is not logged in
      return Scaffold(
        body: Center(
          child: Text('44'.tr),
        ),
      );
    }

    String currentUserId = user.uid;

    return Scaffold(
      endDrawer: NavBar(),
      appBar: AppBar(
        title: Text('28'.tr),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const HomeNavPage(),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(
              child: Text('43'.tr),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String userName = userData['userName'];
          String email = userData['email'];

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/icon.jpg"),
                ),
                Text(
                  '2'.tr,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  email,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 10),
                Container(
                  width: 330,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '99'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUserId)
                                .collection('reports')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, reportsSnapshot) {
                              if (reportsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (reportsSnapshot.hasError) {
                                return Center(
                                  child: Text(
                                      '${"99".tr} ${reportsSnapshot.error}'),
                                );
                              }

                              if (!reportsSnapshot.hasData ||
                                  reportsSnapshot.data == null) {
                                return Center(
                                  child: Text('100'.tr),
                                );
                              }

                              var data = reportsSnapshot.data!;
                              if (data.docs.isEmpty) {
                                return Center(
                                  child: Text('100'.tr),
                                );
                              }
                              return ListView(
                                children:
                                    reportsSnapshot.data!.docs.map((reportDoc) {
                                  var reportData =
                                      reportDoc.data() as Map<String, dynamic>;
                                  String reportTitle =
                                      reportData['textFieldValue'] ?? '';
                                  String selectedMenuItem =
                                      reportData['selectedMenuItem'] ?? '';
                                  Map<String, dynamic>? currentPosition =
                                      reportData['currentPosition']
                                          as Map<String, dynamic>?;

                                  double? latitude =
                                      currentPosition?['latitude'];
                                  double? longitude =
                                      currentPosition?['longitude'];

                                  return ListTile(
                                    title: Text(reportTitle),
                                    subtitle: Text(selectedMenuItem),
                                    // Display additional information if needed
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
