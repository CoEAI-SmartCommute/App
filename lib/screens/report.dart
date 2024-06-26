import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/components/toast/toast.dart';
import 'package:smart_commute/providers/location_provider.dart';
import 'package:smart_commute/services/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File? _selectedImage;
  final TextEditingController _descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text(
          'Report',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text(
                        '${context.watch<LocationProvider>().currentLocation!.latitude} , ${context.watch<LocationProvider>().currentLocation!.longitude}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Describe the unsafe situation',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 8,
                      maxLines: 10,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: InputBorder.none,
                        hintText: 'Type your inputs...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a valid description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  color: Theme.of(context).colorScheme.secondary,
                  strokeWidth: 2,
                  child: (_selectedImage == null)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Select images to upload…',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              MaterialButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    50,
                                  ),
                                ),
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () {
                                  imgInput();
                                },
                                child: const Text(
                                  'Browse Images',
                                  style: TextStyle(color: Colors.white),
                                ),
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
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      elevation: const MaterialStatePropertyAll(0),
                    ),
                    onPressed: () {
                      formKey.currentState!.validate();
                      if (_selectedImage == null) {
                        nullToast('Please select an image');
                        return;
                      }
                      submitForm();
                    },
                    child: const Text('Upload Report'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future imgInput() async {
    await storagePermission();
    if (mounted) {
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
                    final AndroidDeviceInfo androidInfo =
                        await info.androidInfo;
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
      errorToast('We are facing some issue.Try again later');
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

  Future uploadDetails({
    required GeoPoint location,
    required String description,
    required String imgurl,
    required String username,
    required String id,
  }) async {
    final reportDetails =
        FirebaseFirestore.instance.collection('Reports').doc(id);
    final json = {
      'Location': location,
      'Description': description,
      'Username': username,
      'Image': imgurl,
    };
    await reportDetails.set(json);
  }

  void submitForm() async {
    var validation = formKey.currentState!.validate();
    if (!validation) return;
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ));
      },
    );
    formKey.currentState!.save();
    const idGen = Uuid();
    String id = idGen.v1();
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('Reports').child(id);
      await storageRef.putFile(_selectedImage!);
      final imgURL = await storageRef.getDownloadURL();
      if (mounted) {
        await uploadDetails(
            location: GeoPoint(
                context.read<LocationProvider>().currentLocation!.latitude,
                context.read<LocationProvider>().currentLocation!.longitude),
            username: user?.displayName ?? 'NA',
            description: _descriptionController.text,
            imgurl: imgURL,
            id: id);
      }
      if (!mounted) return;
      Navigator.pop(context);

      successfulToast('Reported successfully');

      _descriptionController.text = "";
      _selectedImage = null;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      errorToast(e.toString());
    }
  }
}
