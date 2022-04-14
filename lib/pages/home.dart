import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phone_boookapp/constants.dart';
import 'package:phone_boookapp/pages/components/body.dart';
import 'loading.dart';
import '../services/person.dart';
import 'package:phone_boookapp/services/db.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data={};
  String fetchedItems = '';
  String listViewItems = '';
  bool showOnlineData = true;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  var isLoading = false;
  void savetoDb() async {
    // print(data);
    var temp = jsonEncode(data['userList']);
    // print('try to encode to json ${temp}');
    // print(data.runtimeType);
    // data.map((key, user) => print('isert $key $user'););
    List<dynamic> peoples = data['userList'];
    peoples.map((user) {
     print("Inserting to db");
     DbProvider.db.createUsers(user);
    }).toList();
    print('peoples: $peoples');
    // peoples.map((json) => Person.fromJson(json)).toList();
  }
  Map newData = {};


  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map ;
    Size? size = MediaQuery.of(context).size;
    // print(data['userList'][0]);
    return Scaffold(
      backgroundColor: pColor,
      body: SafeArea(child: Stack(
          children: [
            showOnlineData ? (
                Body(
                data: data,
                showOnlineData: showOnlineData,
                )
            ):(
                Body(
                data: newData,
                showOnlineData: showOnlineData,
                )
            ),
            Positioned(
              top: 0,
        bottom: (size.height*0.65)+15,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15,0,15,0),
          child: Row(
            children: [
              OutlinedButton.icon(
                icon:Icon(
                  Icons.wifi_tethering_outlined,
                  color: pColor,
                ),
                onPressed: (){
                  showOnlineData = true;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Loading()),
                        (Route<dynamic> route) => false,
                  );
                },
                label: Text(
                  "ONLINE",
                  style: TextStyle(
                    color: pColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  side: BorderSide(width: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  primary: secondaryBgColor,
                  backgroundColor: secondaryBgColor,

                ),
              ),
              Spacer(),
              OutlinedButton.icon(
                icon: Icon(
                  Icons.wifi_tethering_off_outlined,
                  color: pColor,
                ),
                onPressed: () async {
                  print('offline');
                  var data;
                  data = await DbProvider.db.getAllUsers();
                  // print(data.runtimeType);
                  print('data test: ${data}');
                  setState(() {
                    showOnlineData = false;
                    newData = {"userList":data};
                  });

                },
                label: Text(
                  "OFFLINE",
                  style: TextStyle(
                    color: pColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  side: BorderSide(width: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  primary: secondaryBgColor,
                  backgroundColor: secondaryBgColor,
                ),
              ),
              Spacer(),
              OutlinedButton(
                child: Icon(
                  Icons.settings,
                  color: pColor,
                ),
                onPressed: (){
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Container(
                          color: Color(0xFF737373),
                          child: Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: primaryBgColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  bottom: 20,
                                  top: 20,
                                  right: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Filtrowanie zaawansowane",
                                          style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.grey[800], fontWeight: FontWeight.bold, letterSpacing: 2.0,
                                          ),
                                      ),
                                      Text(
                                          "Zmieniaj ilość pobranych lub wyświetlanych rekordów",
                                        style: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.grey[500], fontWeight: FontWeight.bold, letterSpacing: 2.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Form(
                                          key: _formKey,
                                          child: Container(
                                            width: size.width,
                                            child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              onSaved: (String? value){fetchedItems=value!;},
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                labelText: 'Liczba pobranych elementów',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Form(
                                          key: _formKey2,
                                          child: Container(
                                            width: size.width,
                                            child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              onSaved: (String? value){listViewItems=value!;},
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                labelText: 'Liczba widocznych elementów',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        icon: Icon(Icons.search),
                                        label: const Text('Wyszukaj'),
                                        onPressed: () {
                                          //print('items:${fetchedItems} ${listViewItems}');
                                          _formKey.currentState?.save();
                                          _formKey2.currentState?.save();
                                          // print(fetchedItems);
                                          personAmount = int.tryParse(fetchedItems) != null ? (personAmount=int.parse(fetchedItems)):(personAmount);
                                          itemList = int.tryParse(listViewItems) != null ? (itemList=int.parse(listViewItems)):(itemList);
                                          // personAmount = int.parse(fetchedItems);
                                          print('items class: ${personAmount} ${itemList}');
                                          if(int.tryParse(fetchedItems) == null){
                                            setState(() {
                                              itemList = itemList;
                                            });
                                            Navigator.pop(context);
                                          }else{
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => Loading()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(width: 20),
                                      showOnlineData ? (
                                          Expanded(
                                            flex: 1,
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.add),
                                              label: const Text('Wpierdol do bazy'),
                                              onPressed: () async{
                                                print('baza');
                                                savetoDb();
                                              },
                                            ),
                                          )
                                      ):(
                                      SizedBox(width: 10)
                                      ),
                                    ]
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  side: BorderSide(width: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  primary: secondaryBgColor,
                  backgroundColor: secondaryBgColor,

                ),
              ),
            ],
          ),
        ),
      ),])),
    );
  }
}
