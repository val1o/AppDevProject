import 'package:flutter/material.dart';
import 'package:final_project_flutter/db.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({super.key});

  @override
  State<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  final urlImages = [
    'https://live.staticflickr.com/239/462459755_85aa6674d3_b.jpg',
    'https://live.staticflickr.com/2185/2258477735_c8016893d7_b.jpg',
    'https://live.staticflickr.com/4068/4398321372_cf6841b555_b.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
          itemCount: urlImages.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = urlImages[index];

            return buildImage(urlImage, index);
          },
          options: CarouselOptions(height: 400)),
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Client Page TODO'),
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
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Materials Page TODO'),
    );
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tools Page TODO'),
    );
  }
}




