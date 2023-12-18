import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';
import 'package:final_project_flutter/loginPage.dart';

class EditPage extends StatefulWidget {
  String username;

  EditPage({required this.username});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController = TextEditingController();

  Mydb mydb = new Mydb();

  @override
  void initState() {
    mydb.open();

    Future.delayed(Duration(milliseconds: 500), () async {
      var data = await mydb.getUser(
          widget.username);
      if (data != null) {
        nameEditingController.text = data["name"];
        usernameEditingController.text = data["username"];
        passwordEditingController.text = data["password"].toString();
        confirmPasswordEditingController.text = data["password"];
        setState(() {});
      } else {
        print(" Not any data with that username " + widget.username);
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit user', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Container(
          child: Column(
            children: [
              TextField(
                controller: nameEditingController,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: usernameEditingController,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              TextField(
                controller: passwordEditingController,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(57, 210, 192, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        )),
                    onPressed: () {
                      mydb.db.rawUpdate(
                          "update users set name = ?, username = ?, password = ? where username = ?",
                          [
                            nameEditingController.text,
                            usernameEditingController.text,
                            passwordEditingController.text,
                            widget.username
                          ]); // added the student to the db
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('User updated')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text("Update User"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}