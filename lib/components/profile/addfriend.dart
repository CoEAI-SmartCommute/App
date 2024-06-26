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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameField(),
              const SizedBox(height: 20),
              _buildPhoneField(),
              const SizedBox(height: 20),
              _buildImportButton(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomFormField(
      controller: _nameController,
      label: 'Full Name',
      hintText: 'Enter Full Name',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return CustomFormField(
      controller: _numberController,
      label: 'Phone Number',
      hintText: 'Enter Phone Number',
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.length < 10) {
          return '10 digits required';
        }
        return null;
      },
    );
  }

  Widget _buildImportButton() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.8,
        child: CustomFlatButton(
          onPressed: _pickContact,
          icon: Icons.contacts,
          label: 'Import from Contacts',
          color: Colors.grey[600]!,
          iconColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomFlatButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.close,
          label: 'Cancel',
          color: Colors.grey[600]!,
          iconColor: Colors.blue,
        ),
        CustomFlatButton(
          onPressed: _isUploading ? null : _submitForm,
          icon: _isUploading ? null : Icons.add,
          label: 'Add Contact',
          color: Colors.grey[600]!,
          iconColor: Colors.blue,
          isLoading: _isUploading,
        ),
      ],
    );
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _uploadContact();
    }
  }

  Future<void> _uploadContact() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final contactData = {
        'name': _nameController.text,
        'number': _numberController.text,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('friend_contacts')
          .add(contactData);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading contact: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.grey[300],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}

class CustomFlatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String label;
  final Color color;
  final Color iconColor;
  final bool isLoading;

  const CustomFlatButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else if (icon != null)
              Icon(icon, color: iconColor, size: 30),
            if (icon != null || isLoading) const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
