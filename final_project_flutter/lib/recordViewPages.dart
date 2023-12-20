import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({Key? key}) : super(key: key);

  @override
  State<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  List<String> machineImages = [];

  TextEditingController newImageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMachineImages();
  }

  Future<void> loadMachineImages() async {
    try {
      // Load the JSON file
      String jsonData = await DefaultAssetBundle.of(context)
          .loadString('assets/materials.json');

      // Parse JSON data
      Map<String, dynamic> data = json.decode(jsonData);

      // Extract machineImages from the JSON
      setState(() {
        machineImages =
        List<String>.from(data["machineImages"].map((image) => image["link"]));
      });
    } catch (e) {
      print('Error loading machine images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: CarouselSlider.builder(
                itemCount: machineImages.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = machineImages[index];

                  return buildImage(urlImage, index);
                },
                options: CarouselOptions(height: 400)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: newImageController,
              decoration: InputDecoration(labelText: 'Enter Image Link'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(82, 72, 156, 1)),
                onPressed: () {
                  String enteredText = newImageController.text;

                  if (enteredText.isNotEmpty) {
                    setState(() {
                      machineImages.add(enteredText);
                      newImageController.clear();
                    });
                  }
                },
                child: Text('Add Image')),
          )
        ],
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
    margin: EdgeInsets.symmetric(horizontal: 12),
    color: Colors.grey,
    child: Image.network(
      urlImage,
      fit: BoxFit.cover,
    ),
  );
}





class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Mydb mydb = new Mydb();

  List<Map> cList = [];

  @override
  void initState() {
    super.initState();
    mydb.open();
    getData();
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
  }

  void getData() {
    Future.delayed(Duration(milliseconds: 500), () async {
      cList = await mydb.db.rawQuery('select * from clients');
      setState(() {});
    });
  }

  void addClient() {
    if (firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        addressController.text.isNotEmpty) {
      mydb.db.rawInsert(
          "insert into clients (first_name, last_name, address) values (?, ?, ?);",
          [
            firstNameController.text,
            lastNameController.text,
            addressController.text
          ]);
      clearFields();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Client added successfully.')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill out all fields.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Image.asset('assets/client.png'),
              ),
            ),
            Container(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(hintText: 'First Name'),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(hintText: 'Address'),
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(193, 119, 103, 1)),
                        onPressed: addClient,
                        child: Text('Assign Client'),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: cList.map((clione) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                                clione["first_name"] + clione["last_name"]),
                            subtitle: Text("Address: " + clione["address"]),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await mydb.db.rawDelete(
                                        "delete from clients where address = ?",
                                        [clione["address"]]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Client deleted.')));
                                    getData();
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {

  String locationMessage = "Current User Location";
  late String lat;
  late String long;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location permissions are denied');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error(
        'Location permissions are permanently denied'
      );
    }
    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) {
        lat = position.latitude.toString();
        long = position.longitude.toString();

        setState(() {
          locationMessage = 'Latitude: $lat, Longitude: $long';
        });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
      ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(locationMessage, textAlign: TextAlign.center,),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    setState(() {
                      locationMessage = "Latitide: $lat, Longitude: $long";
                    });
                    _liveLocation();
                  });
                },
                child: const Text('Get Current Location')),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  _openMap(lat, long);

                },
                child: const Text('Open Google Map'))
          ],
        ),
      ),
    );
  }
}






class MaterialsPage extends StatefulWidget {
  const MaterialsPage({Key? key}) : super(key: key);

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  List materialsList = [];

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/materials.json');
      final data = await json.decode(response);
      setState(() {
        materialsList = data["materials"];
      });
    } catch (e) {
      print('Error reading JSON file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: materialsList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: materialsList.length + 1, // Add 1 for the button
              itemBuilder: (context, index) {
                if (index < materialsList.length) {
                  var material = materialsList[index];
                  return Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.teal[(index + 1) * 100],
                    child: Column(
                      children: [
                        Container(
                            height: 75,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: material["img"] != null
                                ? Image.network(
                                    material["img"],
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/default.png',
                                    fit: BoxFit.cover,
                                  )
                            // Display image here if available (use material["img"])
                            ),
                        Container(
                          height: 45,
                          child: Text(material["name"]),
                        ),
                        Container(
                          height: 25,
                          child: Text('Quantity: ${material["quantity"]}'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Display button
                  return Container(
                    padding: EdgeInsets.all(48),
                    color: Colors.teal[600],
                    child: ElevatedButton(
                      onPressed: () {
                        // Add a new material item when the button is pressed
                        setState(() {
                          materialsList
                              .add({'name': 'New Material', 'quantity': ''});
                        });
                      },
                      child: Text('+'),
                    ),
                  );
                }
              },
            ),
    );
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final FlickManager flickManager = FlickManager(
    videoPlayerController: VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: FlickVideoPlayer(
          flickManager: flickManager,
        ),
      ),
    );
  }
}
