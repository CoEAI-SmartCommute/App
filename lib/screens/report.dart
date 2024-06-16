import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:smart_commute/services/camera.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7F6),
        title: const Text(
          'Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                border: InputBorder.none,
                hintText: 'Choose Destination',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Describe the unsafe situation',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const TextField(
              minLines: 8,
              maxLines: 10,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                border: InputBorder.none,
                hintText: 'Type your inputs...',
              ),
            ),
            const SizedBox(
              height: 11,
            ),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              color: const Color(0xffE8E8E8),
              strokeWidth: 2,
              child: (_selectedImage == null)
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      decoration: BoxDecoration(
                          color: const Color(0xffF3F3F3),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Select images to upload…'),
                          MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                50,
                              ),
                            ),
                            color: const Color(0xffe8e8e8),
                            onPressed: () {
                              imgInput();
                            },
                            child: const Text('Browse Images'),
                          )
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        imgInput();
                      },
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            File(
                              _selectedImage!.path,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(
                    Color(0xffEBEBEB),
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  elevation: const MaterialStatePropertyAll(0),
                ),
                onPressed: () {},
                child: const Text('Upload Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future imgInput() async {
    await storagePermission();
    if (!context.mounted) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Upload Image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'From where would you like to upload image ?',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final DeviceInfoPlugin info = DeviceInfoPlugin();
                  final AndroidDeviceInfo androidInfo = await info.androidInfo;
                  final int androidVersion =
                      int.parse(androidInfo.version.release);
                  if (androidVersion >= 13) {
                    getFromCamera13();
                  } else {
                    getImageGallery();
                  }
                },
              ),
              TextButton(
                child: const Text('Camera'),
                onPressed: () {
                  Navigator.of(context).pop();
                  getImageCamera();
                },
              ),
            ],
          );
        });
  }

  Future getImageGallery() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
    setState(() {
      _selectedImage = File(res!.first.path);
    });
  }

  Future getFromCamera13() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We are facing some issue.Try again later'),
        ),
      );
      return;
    }
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<bool> storagePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
      ].request();

      havePermission =
          request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    // if (!havePermission) {
    //   await openAppSettings();
    // }

    return havePermission;
  }

  Future getImageCamera() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Camera(
          onPickedImage: (File pickedImage) {
            if (mounted) {
              setState(() {
                _selectedImage = File(pickedImage.path);
              });
            }
          },
        ),
      ),
    );
  }
}
