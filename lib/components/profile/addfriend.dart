import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
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
