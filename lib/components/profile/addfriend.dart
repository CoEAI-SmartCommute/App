import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactDialog extends StatefulWidget {
  final String userId;

  const AddContactDialog({super.key, required this.userId});

  @override
  AddContactDialogState createState() => AddContactDialogState();
}

class AddContactDialogState extends State<AddContactDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  bool _isUploading = false;
  bool _validateNum = false;

  bool _validateName = false;
  Future<void> _pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null) {
        setState(() {
          _nameController.text = contact.displayName ?? '';
          _numberController.text = contact.phones?.isNotEmpty == true
              ? contact.phones!.first.value ?? ''
              : '';
          _validateName = false;
          _validateNum = false;
        });
      }
    }
  }

  Future<void> _uploadContact() async {
    if (_numberController.text.length < 10 && _nameController.text.isEmpty) {
      setState(() {
        _validateName = true;
        _validateNum = true;
      });
      return;
    }
    if (_numberController.text.length < 10) {
      setState(() {
        _validateNum = true;
      });

      return;
    }
    if (_nameController.text.isEmpty) {
      setState(() {
        _validateName = true;
      });
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final contactData = {
      'name': _nameController.text,
      'number': _numberController.text,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('friend_contacts')
        .add(contactData);

    setState(() {
      _isUploading = false;
      _validateName = false;
      _validateNum = false;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Text(
                    "Full Name",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _nameController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        fillColor: Colors.grey[300],
                        filled: true,
                        labelText: 'Enter Full Name',
                        errorText: _validateName ? "Invalid Name" : null,
                        labelStyle: TextStyle(color: Colors.grey[600])),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _validateName = true;
                        });
                      } else {
                        setState(() {
                          _validateName = false;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: _numberController,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      fillColor: Colors.grey[300],
                      filled: true,
                      labelText: 'Enter Phone Number',
                      errorText: _validateNum ? "10 digits required" : null,
                      labelStyle: TextStyle(color: Colors.grey[600])),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    if (value.length >= 10) {
                      setState(() {
                        _validateNum = false;
                      });
                    } else {
                      setState(() {
                        _validateNum = true;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: ListTile(
                      textColor: Colors.grey[600],
                      iconColor: Colors.blue,
                      onTap: _pickContact,
                      leading: const Icon(Icons.contacts),
                      title: const FittedBox(
                          child: Text(
                        "Import from Contacts",
                        style: TextStyle(fontSize: 14),
                      )),
                      tileColor: Colors.grey[300],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(10),
                            left: Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.close,
                                color: Colors.blue,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              FittedBox(
                                  child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: _isUploading ? null : _uploadContact,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              _isUploading
                                  ? const SizedBox(
                                      width: 30,
                                      child: CircularProgressIndicator())
                                  : const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              FittedBox(
                                  child: Text(
                                "Add Contact",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
