import 'package:flutter/material.dart';
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
      child: TextButton(
        onPressed: () {
          checkPermission(Permission.location, context);
        },
        child: const Text("Check for permission "),
      ),
    );
  }

  Future<void> checkPermission(
      Permission permission, BuildContext context) async {
    final status = await permission.request();

    /// NOT Granted
    if (!status.isGranted) {
      // var status = await Permission.location.request();
      // print('Permission.location.request() status is $status');
      var status = await Permission.locationWhenInUse.request();
      print('Permission.locationWhenInUse.request() status is $status');
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

    /// Granted
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission Granted"),
        ),
      );
    }
  }
}
