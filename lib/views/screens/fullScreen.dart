import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
import 'dart:io';


// var file = await DefaultCacheManager().getSingleFile(url);
class FullScreen extends StatelessWidget {
  String imgUrl;
  FullScreen({super.key, required this.imgUrl});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<void> setWallpaperFromFile(
      String wallpaperUrl, BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Downloading Started...")));
    try {
      // Saved with this method.
      print("\n\n\n\n $wallpaperUrl...\n\n\n\n");
      var imageId = await ImageDownloader.downloadImage(wallpaperUrl);
      if (imageId == null) {
        print("\n\n\n\n RETURNING...\n\n\n\n");
        return;
      }
      print("\n\n\n\n OK...\n\n\n\n");
      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);

      String? path = await ImageDownloader.findPath(imageId);

      print("\n\n\n $path\n\n\n");
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Downloaded Sucessfully"),
        action: SnackBarAction(
            label: "Open",
            onPressed: () {
              print(path.toString());
              OpenFile.open(path.toString());
            }),
      ));
      print("IMAGE DOWNLOADED");
    } on PlatformException catch (error) {
      print("\n\n\n\nERROR ********************\n\n\n\n\n\n");
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Occured - $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            await setWallpaperFromFile(imgUrl, context);
          },
          child: Text("Set Wallpaper")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imgUrl), fit: BoxFit.cover)),
      ),
    );
  }
}