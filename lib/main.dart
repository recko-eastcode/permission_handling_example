import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Permission Handler Tutorial "),
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              checkPermission(Permission.storage, context);
            },
            child: const Text("Check for permission "),
          ),
          ElevatedButton(
              onPressed: () {
                getImageFromGallery(Permission.photos, context);
              },
              child: const Text("Choose an Image"))
        ],
      ),
    ));
  }

  Future<void> checkPermission(
      Permission permission, BuildContext context) async {
    final status = await permission.request();

    // NOT Granted
    if (!status.isGranted) {
      debugPrint('Permission status is $status');
      if (status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Permission Granted"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Permission Denied"),
          ),
        );
      }
    }

    // Granted
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission Granted"),
        ),
      );
    }
  }

  void getImageFromGallery(Permission permission, BuildContext context) async {
    try {
      XFile? pickImage = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);
    } catch (err) {
      var status = await permission.request();
      if (status.isDenied) {
        debugPrint("Access denied");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("Permission Denied"),
        //   ),
        // );
        showDialogBox(context);
        debugPrint("Error ${err.toString()}");
      } else {
        print("From the else statement exception happen");
      }
    }
  }
}

showDialogBox(context) => showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Permission Denied"),
        content: const Text("Allow access to gallery and photos"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          const CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: openAppSettings,
              child: Text("Settings"))
        ],
      ),
    );
