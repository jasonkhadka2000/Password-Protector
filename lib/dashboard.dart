import 'package:flutter/cupertino.dart';

import 'loading.dart';
import 'package:flutter/material.dart';
import 'package:protect/login.dart';
import 'package:protect/signup.dart';
import 'package:protect/userdb_helper.dart';
import 'database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dashboard extends StatefulWidget {
  late String username;

  Dashboard(String name) {
    this.username = name;
  }

  @override
  State<Dashboard> createState() => _DashboardState(username);
}

class _DashboardState extends State<Dashboard> {
  bool dataloaded = false;
  var datas;
  late String username;

  _DashboardState(String name) {
    this.username = name;
  }

  void delete(String account, String username, String password) async {
    print("inside delete");
    int x = await ProtectHelper.instance.delete(account, username, password);
  }

  List<Widget> showdata() {
    List<Widget> d = [];
    if(datas.length==0)
      {
        d.add(Center(child: Text("You have not save any passwords yet."),));
        return d;
      }
    for (var e in datas) {
      d.add(Card(
        margin: EdgeInsets.all(3),
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text(
                e["account"],
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Username: " + e["username"],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Password: " + e["password"],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextButton.icon(
                          onPressed: () {
                            delete(e["account"], e["username"], e["password"]);
                            loaduserdata();
                          },
                          icon: Icon(Icons.delete),
                          label: Text("Delete")),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    }
    return d;
  }

  void loaduserdata() async {
    var data = await ProtectHelper.instance.queryAll();
    setState(() {
      datas = data;
      print(datas);
      dataloaded = true;
    });
  }

  void insertdata(Map<String, dynamic> row) async {
    print("Datainserted");
    var x = await ProtectHelper.instance.insert(row);
  }

  _displayDialog(BuildContext context) async {
    TextEditingController _accountController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    GlobalKey<FormState> _state = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New account'),
            content: SingleChildScrollView(
              child: Form(
                key: _state,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Account is empty";
                      },
                      controller: _accountController,
                      decoration: InputDecoration(
                          hintText: "Account of", border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    TextFormField(
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Username is empty";
                      },
                      controller: _usernameController,
                      decoration: InputDecoration(
                          hintText: "Username", border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    TextFormField(
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Password is empty";
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: "Password", border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Add account'),
                onPressed: () {
                  Map<String, dynamic> row;
                  if (_state.currentState!.validate()) {
                    row = {
                      ProtectHelper.columnaccountof: _accountController.text,
                      ProtectHelper.columnusername: _usernameController.text,
                      ProtectHelper.columnpassword: _passwordController.text,
                    };
                    insertdata(row);
                    Navigator.of(context).pop();
                    loaduserdata();
                  }
                },
              ),
              TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaduserdata();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Password protect"),
          backgroundColor: Colors.grey[700],
        ),
        body: dataloaded
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(2),
                            child: Text(
                              "Namaste " + username,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(3),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                              child: Text("Logout"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      color: Colors.grey[200],
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: showdata()),
                    ),
                  ],
                ),
              )
            : Spin(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}

class Spin extends StatelessWidget {
  const Spin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: Colors.grey[500],
        size: 40.0,
      ),
    );
  }
}
