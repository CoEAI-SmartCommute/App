import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:smart_commute/components/profile/addfriend.dart';
import 'package:smart_commute/components/toast/toast.dart';

class SaveLocForm extends StatefulWidget {
  final GeoPoint point;
  final String state;
  final String city;
  const SaveLocForm(
      {super.key,
      required this.state,
      required this.city,
      required this.point});

  @override
  State<SaveLocForm> createState() => _SaveLocFormState();
}

class _SaveLocFormState extends State<SaveLocForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isUploading = false;
  String tag = '';
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      insetPadding: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameField(),
                const SizedBox(height: 15),
                _buildAddressField(),
                const SizedBox(height: 15),
                _buildTagButtons(),
                const SizedBox(height: 15),
                _buildCSField(),
                const SizedBox(
                  height: 15,
                ),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagButtons() {
    return Column(
      children: [
        GroupButton(
          isRadio: true,
          onSelected: (value, index, isSelected) {
            tag = value;
          },
          options: GroupButtonOptions(
              borderRadius: BorderRadius.circular(8),
              spacing: 12,
              unselectedColor: Colors.white,
              selectedColor: Colors.red[300]),
          buttons: const ["Home", "Work", "Other"],
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return CustomFormField(
      controller: _nameController,
      label: 'Name',
      hintText: 'Save Address As',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid name';
        }
        return null;
      },
    );
  }

  Widget _buildCSField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'City : ${widget.city}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          'State : ${widget.state}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _buildAddressField() {
    return CustomFormField(
      controller: _addressController,
      label: 'Address',
      hintText: 'House & Building no. , Locality',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid address';
        }
        return null;
      },
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
          color: Theme.of(context).colorScheme.secondary,
          iconColor: Colors.blue,
        ),
        CustomFlatButton(
          onPressed: _isUploading ? null : _submitForm,
          icon: _isUploading ? null : Icons.add,
          label: 'Add Address',
          color: Theme.of(context).colorScheme.secondary,
          iconColor: Colors.blue,
          isLoading: _isUploading,
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _uploadLocation();
    }
  }

  Future<void> _uploadLocation() async {
    _formKey.currentState!.validate();
    if (tag == '') {
      errorToast('Please select the tag');
      return;
    }
    setState(() {
      _isUploading = true;
    });

    try {
      final addressData = {
        'name': _nameController.text,
        'address': _addressController.text,
        'city': widget.city,
        'state': widget.city,
        'latlng': widget.point,
        'tag': tag
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('saved_locations')
          .add(addressData);
      _formKey.currentState!.reset();
      if (!mounted) return;
      Navigator.pop(context);
      successfulToast('Address added successfully');
    } catch (e) {
      errorToast('Error uploading contact: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
