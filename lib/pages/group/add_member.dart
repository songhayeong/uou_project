import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detail_location_detector/pages/group/create_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        membersList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('location')
        .doc('current_location')
        .get()
        .then((map) {
          setState(() {
            membersList.add({
              "location":map['location'],
              "longitude":map['longitude'],
              "altitude":map['altitude'],
            });
          });
    });

    await _firestore
        .collection('users')
        .doc(userMap!['uid'])
        .collection('sensor_data')
        .doc('current_data')
        .get()
        .then((map) {
          setState(() {
            membersList.add({
              "atmos_pressure":map['atmos_pressure'],
              'cell_tpwer_value':map['cell_tower_value'],
              'lux':map['lux'],
              'mag_x':map['mag_x'],
              'mag_y':map['mag_y'],
              'mag_z':map['mag_z'],
              'wifi_rssi':map['wifi_rssi']
            });
          });
    });

  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        print(userMap);
        isLoading = false;
      });
      print(userMap);
    });

    await _firestore
      .collection('users')
      .doc(userMap!['uid'])
      .collection('location')
      .doc('current_location')
      .get()
      .then((value) {
        userMap!.addAll(value.data()!);
    });

    await _firestore
      .collection('users')
      .doc(userMap!['uid'])
      .collection('sensor_data')
      .doc('current_data')
      .get()
      .then((value) {
       userMap!.addAll(value.data()!);
    });

    print(userMap);
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
          'altitude': userMap!['altitude'],
          'latitude': userMap!['latitude'],
          'longitude': userMap!['longitude'],
          'atmos_pressure': userMap!['atmos_pressure'],
          'cell_tower_value': userMap!['cell_tower_value'],
          'lux': userMap!['lux'],
          'mag_x': userMap!['mag_x'],
          'mag_y': userMap!['mag_y'],
          'mag_z': userMap!['mag_z'],
          'wifi_rssi': userMap!['wifi_rssi']
        });

        userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: membersList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => onRemoveMembers(index),
                    leading: const Icon(Icons.account_circle),
                    title: Text(membersList[index]['name']),
                    subtitle: Text(membersList[index]['email']),
                    trailing: const Icon(Icons.close),
                  );
                },
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch,
                    child: Text("Search"),
                  ),
            userMap != null
                ? ListTile(
                    onTap: onResultTap,
                    leading: Icon(Icons.account_box),
                    title: Text(userMap!['name']),
                    subtitle: Text(userMap!['email']),
                    trailing: Icon(Icons.add),
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              child: Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
