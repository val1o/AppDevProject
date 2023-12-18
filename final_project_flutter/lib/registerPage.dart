import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';
import 'package:final_project_flutter/editProfilePage.dart';

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

  List<Map> uList = [];

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    mydb.open();
    getData();
  }

  void clearFields(){
    nameController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void getData(){
    Future.delayed(Duration(milliseconds: 500), () async {
      uList = await mydb.db.rawQuery('select * from users');
      setState(() {

      });
    });
  }

  void addUser(){
    if(nameController.text.isNotEmpty || usernameController.text.isNotEmpty || passwordController.text.isNotEmpty){
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
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match.'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill out all fields.'))
      );
    }


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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              //User form
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(hintText: 'Username'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(hintText: 'Password'),
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(hintText: 'Confirm Password'),
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(193, 119, 103, 1)),
                          onPressed: addUser,
                          child: Text('Insert User'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //List Users
              Container(
                child: Column(
                  children: uList.map((usrone) {
                    return Card(
                      child: ListTile(
                        leading: Text(usrone["name"]),
                        title: Text("Username: " + usrone["username"]),
                        subtitle: Text("Password: " + usrone["password"]),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return EditPage(username: usrone["username"]);
                                    }));
                              },
                              icon: Icon(Icons.key),
                            ),
                            IconButton(
                              onPressed: () async {
                                await mydb.db.rawDelete(
                                    "delete from users where password = ?",
                                    [usrone["password"]]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('User deleted.')));
                                getData();
                              },
                              icon: Icon(Icons.delete), color: Colors.red,)
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )

            ],
          ),
        )
    );
  }
}