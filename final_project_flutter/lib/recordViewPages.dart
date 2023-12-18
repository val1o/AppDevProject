import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({super.key});

  @override
  State<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  final urlImages = [
    'https://www.hitachiaircon.com/id/storage/images/news/news_image_header_f98357527f5e46af57072438ef83fbac.jpg',
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fdygtyjqp7pi0m.cloudfront.net%2Fi%2F35870%2F32095169_1.jpg%3Fv%3D8D662B3DF42D130&f=1&nofb=1&ipt=82fc8c3c78ed44d0b3f4dba92f35dbfa80053c626c7bb4c9fec04f206ec052c9&ipo=images',
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F4f%2Ff4%2F91%2F4ff4917a1015c598414544207f7f80cc.jpg&f=1&nofb=1&ipt=06f08f8eee31523863abc8b3aa0bec42d2f98535b6a3f744b3313921b01b8831&ipo=images'
  ];

  TextEditingController newImageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: CarouselSlider.builder(
                itemCount: urlImages.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = urlImages[index];

                  return buildImage(urlImage, index);
                },
                options: CarouselOptions(height: 400)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: newImageController,
              decoration: InputDecoration(
                labelText: 'Enter Image Link'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(82, 72, 156, 1)),
                onPressed: (){

                  String enteredText = newImageController.text;

                  if(enteredText.isNotEmpty){
                    setState(() {
                      urlImages.add(enteredText);
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
  void initState(){
    super.initState();
    mydb.open();
    getData();
  }

  void clearFields(){
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
  }

  void getData(){
    Future.delayed(Duration(milliseconds: 500), () async {
      cList = await mydb.db.rawQuery('select * from clients');
      setState(() {

      });
    });
  }

  void addClient(){
    if(firstNameController.text.isNotEmpty || lastNameController.text.isNotEmpty || addressController.text.isNotEmpty){
      mydb.db.rawInsert(
        "insert into clients (first_name, last_name, address) values (?, ?, ?);",
        [
          firstNameController.text,
          lastNameController.text,
          addressController.text
        ]);
      clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Client added successfully.'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill out all fields.'))
      );
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
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(193, 119, 103, 1)),
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
                            title: Text(clione["first_name"] + clione["last_name"]),
                            subtitle: Text("Address: " + clione["address"]),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await mydb.db.rawDelete(
                                        "delete from clients where address = ?",
                                        [clione["address"]]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Client deleted.')));
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Overview Page TODO'),
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

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/materials.json');
    final data = await json.decode(response);
    setState(() {
      materialsList = data["materials"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: materialsList.length + 1, // Add 1 for the button
      itemBuilder: (context, index) {
        if (index < materialsList.length) {
          // Display material item
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
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(materialsList[index]),
                ),
                Container(
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text('Quantity: '),
                ),
              ],
            ),
            //child: Text(materialsList[index]),
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
                  materialsList.add('New Material');
                });
              },
              child: Text('+'),
            ),
          );
        }
      },
    );
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});



  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {

  final FlickManager flickManager = FlickManager(videoPlayerController: VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16/9,
        child: FlickVideoPlayer(flickManager: flickManager,),
      ),
    );
  }


}
