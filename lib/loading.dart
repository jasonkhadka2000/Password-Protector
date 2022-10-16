import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'userdb_helper.dart';
import 'login.dart';
import 'signup.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {


  void choosenavigation() async
  {
    List<Map<String,dynamic>> row=await UserHelper.instance.queryAll();
    if(row.length>0)
      {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    else{
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SignUp(),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choosenavigation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SpinKitThreeBounce(
          color: Colors.grey[500],
          size: 40.0,
        ),
      ),
    );
  }
}
