import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_commute/screens/permission.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  String _gender = 'male';

  bool _isFullNameValid = true;
  bool _isEmailValid = true;
  bool _isPhoneValid = false;
  bool _isDobValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = user?.email ?? '';
    _fullNameController.text = user?.displayName ?? '';
    _isFullNameValid = _fullNameController.text.isNotEmpty;
    _isEmailValid =
        _emailController.text.isNotEmpty && _emailController.text.contains('@');
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
        _isDobValid = true;
      });
    }
  }

  void _register() async {
    if (_isFullNameValid && _isEmailValid && _isPhoneValid && _isDobValid) {
      final uid = user!.uid;
      final data = {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'dob': _dobController.text,
        'gender': _gender,
        'uid': user?.uid,
      };

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set(data);

        await _saveUserDataLocally(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PermissionScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
    }
  }

  Future<void> _saveUserDataLocally(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', userData['fullName']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('phone', userData['phone']);
    await prefs.setString('dob', userData['dob']);
    await prefs.setString('gender', userData['gender']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          ),
        ),
        backgroundColor: const Color(0xffF7F7F6),
        title: const Text(
          'Register Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: 'profileImage',
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user?.photoURL ?? '',
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Ionicons.person_circle,
                      size: 100,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextInput(
                controller: _fullNameController,
                label: 'Full Name',
                icon: Ionicons.person,
                onChanged: (value) {
                  setState(() {
                    _isFullNameValid = value.isNotEmpty;
                  });
                },
                isValid: _isFullNameValid,
              ),
              const SizedBox(height: 20),
              _buildTextInput(
                controller: _emailController,
                keyBoard: TextInputType.emailAddress,
                label: 'Email',
                icon: Ionicons.mail,
                onChanged: (value) {
                  setState(() {
                    _isEmailValid = value.isNotEmpty && value.contains('@');
                  });
                },
                isValid: _isEmailValid,
              ),
              const SizedBox(height: 20),
              _buildTextInput(
                controller: _phoneController,
                keyBoard: TextInputType.phone,
                label: 'Phone Number',
                icon: Ionicons.call,
                onChanged: (value) {
                  setState(() {
                    _isPhoneValid = value.isNotEmpty && value.length == 10;
                  });
                },
                isValid: _isPhoneValid,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextInput(
                    controller: _dobController,
                    label: 'Date of Birth',
                    icon: Ionicons.calendar,
                    onChanged: (value) {},
                    isValid: _isDobValid,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Gender", style: TextStyle(fontSize: 18)),
                  _buildGenderOption(Ionicons.man, 'Male', 'male'),
                  _buildGenderOption(Ionicons.woman, 'Female', 'female'),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.grey[300],
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    elevation: const MaterialStatePropertyAll(0),
                  ),
                  onPressed: _register,
                  icon: const Icon(
                    Ionicons.log_in,
                    color: Colors.blue,
                  ),
                  label: const Text('Register',
                      style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    required bool isValid,
    TextInputType keyBoard = TextInputType.name
  }) {
    return TextField(
      keyboardType:keyBoard ,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isValid
            ? const Icon(
                Ionicons.checkmark,
                color: Colors.green,
              )
            : null,
        border: const UnderlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildGenderOption(IconData icon, String title, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _gender == value ? Colors.blue : Colors.grey,
                )),
            child: Icon(
              icon,
              size: 50,
              color: _gender == value ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
                color: _gender == value ? Colors.blue : Colors.grey,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
