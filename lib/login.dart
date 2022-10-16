import 'userdb_helper.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  String warning = "";

  void login() async {
    String uname = "", pword = "";
    var x = await UserHelper.instance.queryAll();
    for (var e in x) {
      uname = e["username"];
      pword = e["password"];
    }
    if (uname == name.text && pword == password.text) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Dashboard(uname),
        ),
      );
    } else {
      setState(() {
        warning = "Invalid credentials";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Password protector"),
          backgroundColor: Colors.grey[700],
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[100],
                padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Please login to view passwords",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(6),
                          padding: EdgeInsets.all(6),
                          child: TextField(
                            controller: name,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Name',
                                hintText: 'Enter Your Name'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(6),
                          padding: EdgeInsets.all(6),
                          child: TextField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Password',
                              hintText: 'Enter Your password',
                            ),
                          ),
                        ),
                        Text(
                          warning,
                          style: TextStyle(
                            color: Colors.red[700],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(6),
                            padding: EdgeInsets.all(6),
                            child: ElevatedButton(
                                onPressed: () {
                                  login();
                                },
                                child: Text("Login")))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
