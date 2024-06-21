import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


class AddContactDialog extends StatefulWidget {
  final String userId;

  const AddContactDialog({super.key, required this.userId});

  @override
  AddContactDialogState createState() => AddContactDialogState();
}

class AddContactDialogState extends State<AddContactDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  File? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null) {
        setState(() {
          _nameController.text = contact.displayName ?? '';
          _numberController.text = contact.phones?.isNotEmpty == true
              ? contact.phones!.first.value ?? ''
              : '';
        });
      }
    }
  }

  Future<void> _uploadContact() async {
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    String? imageUrl;
    if (_imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('contact_images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(_imageFile!);
      imageUrl = await ref.getDownloadURL();
    }

    final contactData = {
      'name': _nameController.text,
      'number': _numberController.text,
      'image_url': imageUrl,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('friend_contacts')
        .add(contactData);

    setState(() {
      _isUploading = false;
    });
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _numberController,
            decoration: const InputDecoration(labelText: 'Number'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          _imageFile != null
              ? Image.file(
                  _imageFile!,
                  height: 100,
                )
              : TextButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _pickContact,
            child: const Text('Pick from Contacts'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isUploading ? null : _uploadContact,
          child: _isUploading
              ? const CircularProgressIndicator()
              : const Text('Add Contact'),
        ),
      ],
    );
  }
}
