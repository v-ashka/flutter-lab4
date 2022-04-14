import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phone_boookapp/constants.dart';
import 'package:phone_boookapp/services/db.dart';
import '../services/user_list.dart';
import '../services/person.dart';
class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List dataTemp = [];
  void setupData() async{
    // Users instance = Users();
    // await instance.getUsers();
    PersonNetworkService personService = PersonNetworkService();
    dataTemp = await personService.fetchPersons(personAmount);
    await DbProvider.db.getAllUsers();
    // print(dataTemp[0].imageUrl);
    // dataTemp =await personService.fetchPersons(20);
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'userList': dataTemp,
    });
  }

  @override
  void initState() {
    super.initState();
    setupData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pColor,
      body: Center(
        child: SpinKitDancingSquare(
          color: Colors.white,
          size: 150,
        ),
      ),
    );
  }
}
