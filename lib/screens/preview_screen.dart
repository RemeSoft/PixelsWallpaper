import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class PreviewScreen extends StatefulWidget {
  // require constant
  final String imageUri;

  // constructor
  const PreviewScreen({Key? key, required this.imageUri}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  // setting up loading
  bool isLoading = false;

  // setAsWallpaper Function
  setAsWallpaper() async {
    setState(() => isLoading = true);
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUri);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
    setState(() => isLoading = false);
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
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              widget.imageUri,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () => setAsWallpaper(),
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
                          "Set Wallpaper",
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
        ],
      ),
    );
  }
}
