import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:final_project_flutter/loginPage.dart';
import 'package:final_project_flutter/registerPage.dart';
import 'package:final_project_flutter/recordViewPages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: ScaffoldMessenger(
        key: GlobalKey<ScaffoldMessengerState>(),
        child: const Scaffold(
          body: LoginPage(),
        ),
      ),
      routes: {
        '/listRecordsPage': (context) => const ListRecordsPage(),
        '/createRecordPage': (context) => const CreateRecordPage(),
        '/registerPage': (context) => const RegisterPage(),
        '/generalRecordPage': (context) => const GeneralRecordPage(),
      },
    );
  }
}



class GeneralRecordPage extends StatefulWidget {
  const GeneralRecordPage({super.key});

  @override
  State<GeneralRecordPage> createState() => _GeneralRecordPageState();
}

class _GeneralRecordPageState extends State<GeneralRecordPage> {
  List<Map> ClientInfo = [];
  Mydb mydb = new Mydb();

  int activeIndex = 2;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [];
    pages.add(MachinePage());
    pages.add(ClientPage());
    pages.add(OverviewPage());
    pages.add(MaterialsPage());
    pages.add(ToolsPage());
    mydb.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Record Information',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body:  pages[activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        unselectedIconTheme:
        IconThemeData(color: Color.fromRGBO(57, 210, 192, 1)),
        selectedIconTheme:
        IconThemeData(color: Color.fromRGBO(193, 119, 103, 1), size: 40),
        selectedItemColor: Color.fromRGBO(193, 119, 103, 1),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: activeIndex,
        onTap: (index) => setState(() => activeIndex = index),
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.plug), label: 'Machine',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Client'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'General'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.box), label: 'Materials'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.screwdriverWrench), label: 'Tools')

        ],
      ),
    );
  }
}




class EditRecordPage extends StatefulWidget {
  int rid;

  EditRecordPage({required this.rid});

  @override
  State<EditRecordPage> createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}






class CreateRecordPage extends StatefulWidget {
  const CreateRecordPage({super.key});

  @override
  State<CreateRecordPage> createState() => _CreateRecordPageState();
}

class _CreateRecordPageState extends State<CreateRecordPage> {
  TextEditingController rollno = TextEditingController();
  TextEditingController recordName = TextEditingController();
  TextEditingController status = TextEditingController();

  //TextEditingController date = TextEditingController();

  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement iniState
    super.initState();
    mydb.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Record'),
          backgroundColor: const Color.fromRGBO(57, 210, 192, 1),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
                child: TextField(
                  controller: recordName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Record Name',
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: TextField(
                  controller: status,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Record Status',
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: TextField(
                  controller: rollno,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Record Number',
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(193, 119, 103, 1)),
                    onPressed: () {
                      mydb.db.rawInsert(
                          "insert into records (roll_no, name, status) values (?, ?, ?);",
                          [
                            rollno.text,
                            recordName.text,
                            status.text,
                          ]);
                      recordName.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Save')),
              )
            ],
          ),
        ));
  }
}




class ListRecordsPage extends StatefulWidget {
  const ListRecordsPage({super.key});

  @override
  State<ListRecordsPage> createState() => _ListRecordsPageState();
}

class _ListRecordsPageState extends State<ListRecordsPage> {
  List<Map> recordsList = [];
  Mydb mydb = new Mydb();

  @override
  void initState() {
    // TODO: implement initState
    mydb.open();
    getData();
    super.initState();
  }

  void getData() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      //Use 500ms as delay to allow time for db to reinitialize
      recordsList = await mydb.db.rawQuery('select * from records');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Records'),
        backgroundColor: const Color.fromRGBO(57, 210, 192, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: recordsList.length == 0
              ? Container(
              margin: const EdgeInsets.fromLTRB(0, 275, 0, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  FloatingActionButton.large(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createRecordPage');
                    },
                    backgroundColor: const Color.fromRGBO(57, 210, 192, 1),
                    child: const Icon(Icons.add),
                    elevation: 0,
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: const Text(
                        'Add Record',
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromRGBO(57, 210, 192, 1)),
                      ))
                ],
              ))
              : Column(
            children: recordsList.map((recordOne) {
              return Card(
                  child: ListTile(
                    leading: const FaIcon(FontAwesomeIcons.folder),
                    onTap: () {
                      Navigator.pushNamed(context, '/generalRecordPage');
                    },
                    title: Text(recordOne["name"]),
                    isThreeLine: true,
                    subtitle: Text("Id: " +
                        recordOne["rid"].toString() +
                        ", Name: " +
                        recordOne["name"] +
                        ", Date: " +
                        recordOne["date"].toString() +
                        ", Status: " +
                        recordOne["status"].toString()),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditRecordPage(
                                          rid: recordOne["rid"])));
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              await mydb.db.rawDelete(
                                  "delete from records where roll_no = ?",
                                  [recordOne["roll_no"]]);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Record deleted successfully')));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ));
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: recordsList.isNotEmpty

          ? FloatingActionButton(
              onPressed: () {
              Navigator.pushNamed(context, '/createRecordPage');
              },
              backgroundColor: const Color.fromRGBO(57, 210, 192, 1),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
