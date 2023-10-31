import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jct/screens/welcome_screen.dart';
import 'package:jct/widgets/user_image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bool isObscurePassword = true;
  File? selectedImage;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isNameEditable = false;
  bool isMobileNumberEditable = false;
  bool isAddressEditable = false;
  bool isEditing = false;

  void saveChanges() async {
    final name = nameController.text;
    final mobileNumber = mobileNumberController.text;
    final address = addressController.text;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$mobileNumber.jpg');

    await storageRef.putFile(selectedImage!);
    final imageUrl = await storageRef.getDownloadURL();

    print('Name: $name');
    print('Mobile Number: $mobileNumber');
    print('Address: $address');
    print('Image URL: $imageUrl');

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    bool validateFullName() {
      final fullName = nameController.text;
      if (fullName.length <= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Full Name must be more than 2 characters.'),
          ),
        );
        return false;
      }
      return true;
    }

    bool validateHomeAddress() {
      final address = addressController.text;
      if (address.length <= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Home Address must be more than 5 characters.'),
          ),
        );
        return false;
      }
      return true;
    }

    bool validateMobileNumber() {
      final mobileNumber = mobileNumberController.text;
      if (mobileNumber.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mobile number must be 10 digits.'),
          ),
        );
        return false;
      }
      return true;
    }

    Widget buildHomeAddressField() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: addressController,
                enabled: isAddressEditable,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  labelText: 'Home Address',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Home Address',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isAddressEditable ? Icons.save : Icons.edit,
                color: Colors.blue,
              ),
              onPressed: () {
                validateHomeAddress();
                setState(() {
                  isAddressEditable = !isAddressEditable;
                });
              },
            ),
          ],
        ),
      );
    }

    Widget buildFullNameField() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: nameController,
                enabled: isNameEditable,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  labelText: 'Full Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isNameEditable ? Icons.save : Icons.edit,
                color: Colors.blue,
              ),
              onPressed: () {
                validateFullName();
                setState(() {
                  isNameEditable = !isNameEditable;
                });
              },
            ),
          ],
        ),
      );
    }

    Widget buildMobileNumberField() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: mobileNumberController,
                enabled: isMobileNumberEditable,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  labelText: 'Mobile no',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Mobile no',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isMobileNumberEditable ? Icons.save : Icons.edit,
                color: Colors.blue,
              ),
              onPressed: () {
                validateMobileNumber();
                setState(() {
                  isMobileNumberEditable = !isMobileNumberEditable;
                });
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserImagePicker(
                    onPickedImage: (pickedImage) {
                      setState(() {
                        selectedImage = pickedImage;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              buildFullNameField(),
              buildMobileNumberField(),
              buildHomeAddressField(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: saveChanges,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                        ),
                      );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}