import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wesafe/models/error_Model.dart';
import 'package:wesafe/models/user_Model.dart';
import 'package:wesafe/states/mainMenu.dart';
import 'package:wesafe/states/myservice.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showImage.dart';
import 'package:wesafe/widgets/showTitle.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double size;
  bool remember = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage(),
                buildShowTitle(),
                buildUser(),
                buildPassword(),
                buildRemember(),
                buildLogin()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildRemember() {
    return Container(
      width: size * 0.6,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: ShowTitle(
          title: 'Remember Me',
          index: 1,
        ),
        value: remember,
        onChanged: (value) {
          setState(() {
            remember = value;
            print('#### remember = $remember');
          });
        },
      ),
    );
  }

  Container buildLogin() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            // print('NO space');
            checkLogin(userController.text, passwordController.text);
          }
        },
        child: Text('เข้าสู่ระบบ'),
      ),
    );
  }

  Future<Null> checkLogin(String user, String pass) async {
    try {
      final client = HttpClient();
      final request =
          await client.postUrl(Uri.parse("${MyConstant.webService}CheckEmp"));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.write('{"userName": "$user",   "passwd": "$pass"}');
      final response = await request.close();

      UserModel userModel;
      Errormodel errorModel;
      response.transform(utf8.decoder).listen((contents) {
        if (contents.contains('Error')) {
          contents = contents.replaceAll("[", "").replaceAll("]", "");
          errorModel = Errormodel.fromJson(json.decode(contents));
          normalDialog(context, 'Error', errorModel.error);
        } else {
          userModel = UserModel.fromJson(json.decode(contents));
          if (userModel.ownerID.length > 1) {
            routeToMultiOwner(userModel);
          } else {
            routeToWorkMainMenu(userModel);
          }
        }
      });
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }

  void routeToMultiOwner(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Myservice(
          user_model: userModel,
        ),
      ),
    );
  }

  void routeToWorkMainMenu(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainMenu(
          userModel: userModel,
        ),
      ),
    );
  }

  ShowTitle buildShowTitle() => ShowTitle(
        title: MyConstant.appName,
        index: 0,
      );

  Container buildImage() {
    return Container(
      width: size * 0.6,
      child: ShowImage(),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill password';
          } else {
            return null;
          }
        },
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill User';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity),
          labelText: 'User :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}