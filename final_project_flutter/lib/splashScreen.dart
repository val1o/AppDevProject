import 'package:final_project_flutter/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => LoginPage(),
          ));
    });

  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:
          [Color.fromRGBO(57, 210, 192, 1), Colors.white],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ac_unit,
              size: 80,
              color: Color.fromRGBO(82, 72, 156, 1),
            ),
            SizedBox(height: 20),
            Text('Launching HVAC Management...', style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(82, 72, 156, 1),
              fontSize: 22
            ),)
          ],
        ),
      ),
    );
  }
}
