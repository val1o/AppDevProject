import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Mydb mydb = new Mydb();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    mydb.open();
  }

  void clearFields(){
    nameController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          'Create your profile',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/6979509.png'),
                  backgroundColor: Color.fromRGBO(154, 173, 191, 1),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Name'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Username'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Confirm Password'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                height: 50,
                width: 335,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(193, 119, 103, 1)),
                  onPressed: () {

                    if (passwordController.text == confirmPasswordController.text){
                      mydb.db.rawInsert(
                          "insert into users (name, username, password) values (?, ?, ?);",
                          [
                            nameController.text,
                            usernameController.text,
                            passwordController.text
                          ]);
                      clearFields();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User added successfully.'))
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match.'))
                      );
                    }

                    //Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          )),
    );
  }
}