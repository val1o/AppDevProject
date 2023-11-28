import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _MyAppState();
}

class _MyAppState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Mydb mydb = new Mydb();

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    mydb.open();
  }

  void showLoginFailedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login failed, please verify information.')));
  }

  void showEmptyInfoSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username and password.')));
  }

  void clearText() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Stack(
              children: [
                Image(
                  image: AssetImage('assets/pexels-photo-2539462.jpeg'),
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 200,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(57, 210, 192, 1)),
                      ),
                    )),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              width: 300,
              height: 50,
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Username"),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              width: 300,
              height: 50,
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Password"),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              height: 50,
              width: 300,
              child: ElevatedButton(
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(57, 210, 192, 1)),
                onPressed: () async {

                  final username = usernameController.text;
                  final password = passwordController.text;

                  var user = await mydb.getUser(username);

                  if (user != null && user['password'] == password) {
                    Navigator.pushNamed(context, '/listRecordsPage');
                    clearText();
                  } else if (username == "" || password == "") {
                    showEmptyInfoSnackBar();
                  } else {
                    showLoginFailedSnackBar();
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registerPage');
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(57, 210, 192, 1)),
                  child: const Text('Register')),
            )
          ],
        ),
      ),
    );
  }
}