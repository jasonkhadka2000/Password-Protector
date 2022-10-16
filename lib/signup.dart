import 'package:flutter/material.dart';
import 'userdb_helper.dart';
import 'dashboard.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();

  String namewarning = "";
  String emailwarning = "";
  String passwordwarning = "";
  String cpasswordwarning = "";

  void SignUp(String name, String email, String password) async {
    Map<String, dynamic> row = {
      UserHelper.columnusername: name,
      UserHelper.columnemail: email,
      UserHelper.columnpassword: password,
    };
    List<Map<String, dynamic>> row2 = await UserHelper.instance.queryAll();

    if (row2.length == 0) {
      int insert = await UserHelper.instance.insert(row);
      print(insert);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Dashboard(name),
        ),
      );
    }
  }

  void SignupVerify() {
    String formname, formemail, formpassword, formcpassword;
    bool verified = true;
    formname = name.text;
    formemail = email.text;
    formpassword = password.text;
    formcpassword = cpassword.text;

    if (formname == "") {
      verified = false;
      setState(() {
        namewarning = "Name field can not be emoty";
      });
    } else {
      setState(() {
        namewarning = "";
      });
    }

    if (formemail == "") {
      verified = false;
      setState(() {
        emailwarning = "Email field can not be empty";
      });
    } else {
      setState(() {
        emailwarning = "";
      });
    }

    if (formpassword == "" && formpassword.length < 6) {
      verified = false;
      setState(() {
        passwordwarning = "Password is too short";
      });
    } else {
      setState(() {
        passwordwarning = "";
      });
    }

    if (formpassword != formcpassword) {
      verified = false;
      setState(() {
        cpasswordwarning = "Passwords do not match";
      });
    } else {
      setState(() {
        cpasswordwarning = "";
      });
    }

    if (verified == true) {
      print("verified");
      SignUp(formname, formemail, formpassword);
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
        body: Center(
          child: Container(
            color: Colors.grey[100],
            padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
            margin: EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("please sign up using the form below"),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        TextField(
                          controller: name,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Name',
                              hintText: 'Enter Your Name'),
                        ),
                        Text(
                          namewarning,
                          style: TextStyle(color: Colors.red[800]),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(4),
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Enter Your Email'),
                        ),
                      ),
                      Text(
                        emailwarning,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(4),
                        child: TextField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Password',
                            hintText: 'Enter Your Password',
                          ),
                        ),
                      ),
                      Text(
                        passwordwarning,
                        style: TextStyle(color: Colors.red[800]),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(4),
                        child: TextField(
                          controller: cpassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter you password',
                          ),
                        ),
                      ),
                      Text(cpasswordwarning,
                          style: TextStyle(color: Colors.red[800]))
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        SignupVerify();
                      },
                      child: Text("Sign up"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
