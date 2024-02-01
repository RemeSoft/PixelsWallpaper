import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pixels_wallpaper/screens/preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // pixels api url
  final String apiKey = "T0Ql2ydKarH3tmrCwAhkVlRD8dUubDcaHkGfNJTJVqt1lAxt9gh8Jgll";
  final String generalUri = "https://api.pexels.com/v1/curated?per_page=20";
  int loadCount = 0;
  List photos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  // image loader funciton
  loadImage() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    await http.get(Uri.parse(generalUri), headers: {'Authorization': apiKey}).then((value) {
      Map resposne = jsonDecode(value.body);
      setState(() => photos = resposne['photos']);
      setState(() => isLoading = false);
    });
  }

  // more image loader
  moreImageLoader() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    loadCount += 1;
    String moreImageLoadUri = '$generalUri&page=$loadCount';
    http.get(Uri.parse(moreImageLoadUri), headers: {'Authorization': apiKey}).then((value) {
      Map resposne = jsonDecode(value.body);
      setState(() => photos.addAll(resposne['photos']));
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pixels Wallpaper",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Stack(children: [
          GridView.builder(
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PreviewScreen(
                                imageUri: photos[index]['src']['large2x'],
                              ))),
                  child: Container(
                    color: Colors.blue[50],
                    child: Image.network(
                      photos[index]['src']['tiny'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () => moreImageLoader(),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(234, 60, 166, 252),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          "Load More",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ]));
  }
}
