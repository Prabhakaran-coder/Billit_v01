import 'package:flutter/material.dart';
import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/product_db_data.dart';

final _formKey = GlobalKey<FormState>();
late ProductDatabaseHelper _databaseHelper;
bool gst = false;
String? _selectedName;

final List<String> _customerState = [
  'AndraPradesh',
  'Kerala',
  'Karnataka',
  'Tamilnadu'
];

// Controllers
final TextEditingController _NameController = TextEditingController();
final TextEditingController _AddressController = TextEditingController();
final TextEditingController _ContactController = TextEditingController();
final TextEditingController _districtController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _pincodeController = TextEditingController();
final TextEditingController _gstController = TextEditingController();
bool hasInitializedProfile = false;
bool isEditable = false;
/// Create or Update Profile in DB
Future<void> addOrUpdateProfile(bool isUpdate, {int? existingId}) async {
  final String name = _NameController.text.trim();
  final String address = _AddressController.text.trim();
  final String district = _districtController.text.trim();
  final String state = _selectedName ?? '';
  final int contact = int.tryParse(_ContactController.text) ?? 0;
   final String email = _emailController.text.trim();
  final int pincode = int.tryParse(_pincodeController.text) ?? 0;
  final String gstNumber = _gstController.text.trim().toUpperCase();

  if (name.isNotEmpty && address.isNotEmpty && contact > 0) {
    final newProfile = Profile(
      id: existingId,
      profileName: name,
      profileAddress: address,
      emailAddress: email,
      district: district,
      state: state,
      
      profileContact: contact,
      gst: gstNumber,
      pincode: pincode,
    );

    if (isUpdate) {
      await _databaseHelper.updateProfile(newProfile);
      print("Profile updated successfully");
    } else {
      await _databaseHelper.insertProfile(newProfile);
      print("Profile created successfully");
    }

    // Clear text fields after saving
    _NameController.clear();
    _AddressController.clear();
    _ContactController.clear();
    _districtController.clear();
    _pincodeController.clear();
    _gstController.clear();
  }
}

/// Main Dialog
void profileDialog(BuildContext context) {
   final nameExp = RegExp(r'^[a-zA-Z ]+$');
      final stateExp = RegExp(r'^[a-zA-Z]+$');
      final alphanumericNoSpace = RegExp(r'^[a-zA-Z0-9]+$');
  _databaseHelper = ProductDatabaseHelper.instance; 
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      
      int? existingProfileId;

      return StatefulBuilder(
        
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shadowColor: const Color.fromARGB(255, 244, 153, 96),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder<List<Profile>>(
              future: _databaseHelper.getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(50),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text('Error loading profile: ${snapshot.error}'),
                  );
                }

                final hasProfile =
                    snapshot.hasData && snapshot.data!.isNotEmpty;

                if (!isEditable && hasProfile) {
                  final profile = snapshot.data!.first;
                  existingProfileId = profile.id;
                  _NameController.text = profile.profileName ?? '';
                  _AddressController.text = profile.profileAddress ?? '';
                  _ContactController.text =
                      profile.profileContact?.toString() ?? '';
                  _districtController.text = profile.district ?? '';
                  _selectedName = profile.state;
                  _emailController.text = profile.emailAddress.toString()??'';
                  _pincodeController.text = profile.pincode?.toString() ?? '';
                  _gstController.text = profile.gst ?? '';
                  isEditable = false; 
                  hasInitializedProfile = true;
                } else {
                  isEditable = true; 
                }
                if(hasProfile){
                return Container(
                  width: double.infinity,
                  height: 500,
                  padding: const EdgeInsets.all(30),
                  child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                    children: [
                      Center(
                        child: const Text('Profile',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      const Divider(),
                      const SizedBox(height: 15),

                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                   Expanded(child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Text('Name',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                      _buildTextField(
                                  'Name', _NameController,isEditable:  isEditable,regEx: nameExp),
                                    ],
                                   )),
                              const SizedBox(width: 15),
                             Expanded(child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text('Address',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                _buildTextField('Address', _AddressController,
                                isEditable:   isEditable),
                              ],
                             )),
                              const SizedBox(width: 15),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text('District',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                   _buildTextField('District', _districtController,
                                isEditable:   isEditable,regEx: stateExp),
                                ],
                              )),
                              const SizedBox(width: 15),
                          
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text('State',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                  DropdownButtonFormField<String>(
                                value: _selectedName,
                                isDense: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Select State",
                                ),
                                items: _customerState.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: isEditable
                                    ? (newValue) {
                                        setState(() {
                                          _selectedName = newValue!;
                                        });
                                      }
                                    : null,
                              ),
                                ],
                              )),
                                ],
                              ),
                              const SizedBox(height: 15),
                          
                             Row(
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text('Contact',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                     _buildTextField(
                                  'Contact', _ContactController,isEditable:  isEditable,
                                  keyboard: TextInputType.number,maxLength: 10,minLength: 10),
                                  ],
                                )),
                                const SizedBox(width: 15),
                                 Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text('Email',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                     _buildTextField(
                                  'Email Address', _emailController,isEditable:  isEditable,
                                  ),
                                  ],
                                )),
                              const SizedBox(width: 15),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text('Pincode',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                  _buildTextField('Pincode', _pincodeController,
                               isEditable:    isEditable,
                                  keyboard: TextInputType.number,minLength: 6,maxLength: 6,numbersOnly: true),
                                ],
                              )),
                              const SizedBox(width: 15),
                             Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text('GST Number',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                 _buildTextField('GST Number', _gstController,
                                 isEditable:  isEditable,regEx: alphanumericNoSpace),
                              ],
                             )),
                              ],
                             ),
                              const SizedBox(height: 30),
                          
                              if (hasProfile)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      isEditable = !isEditable;
                                    });
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: Text(isEditable
                                      ? 'Cancel Edit'
                                      : 'Edit Profile'),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(                            
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ?? false) {
                                await addOrUpdateProfile(hasProfile,
                                    existingId: existingProfileId);
                                  setState(() {
                                      isEditable = false;
                                    });
                                Navigator.of(context).pop();
                              }else {
                                      print("Validation failed");
                                    }
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF); 
                                      },
                                    ),
                                    overlayColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFF1EB386); 
                                        }
                                        return Color(
                                            0xFF1EB386); 
                                      },
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                        Color(0xFF1EB386)),
                                  ),
                                  child: Text("Save")),
                              SizedBox(width: 15.0),
                              ElevatedButton(
                                  onPressed: () {
                                    _NameController.clear();
                                    _AddressController.clear();
                                    _ContactController.clear();
                                    _pincodeController.clear();
                                    Navigator.of(context).pop(context);
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF); 
                                      },
                                    ),
                                    overlayColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFF5B89FF); 
                                        }
                                        return Color(
                                            0xFF5B89FF); 
                                      },
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                        Color(0xFF5B89FF)),
                                  ),
                                  child: Text("Close")),
                            ],
                          ),
                    ],
                  ),
                );
                }
                return Container(
                  width: double.infinity,
                  height: 500,
                  padding: const EdgeInsets.all(30),
                  child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                    children: [
                      Center(
                        child: const Text('Profile',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      const Divider(),
                      const SizedBox(height: 15),

                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                   Expanded(child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Text('Name',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                      _buildTextField(
                                  'Name', _NameController, regEx: nameExp),
                                    ],
                                   )),
                              const SizedBox(width: 15),
                             Expanded(child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text('Address',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                _buildTextField('Address', _AddressController,
                                 ),
                              ],
                             )),
                              const SizedBox(width: 15),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text('District',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                   _buildTextField('District', _districtController,
                                 regEx: stateExp),
                                ],
                              )),
                              const SizedBox(width: 15),
                          
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text('State',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                  DropdownButtonFormField<String>(
                                value: _selectedName,
                                isDense: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Select State",
                                ),
                                items: _customerState.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: isEditable
                                    ? (newValue) {
                                        setState(() {
                                          _selectedName = newValue!;
                                        });
                                      }
                                    : null,
                              ),
                                ],
                              )),
                                ],
                              ),
                              const SizedBox(height: 15),
                          
                             Row(
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text('Contact',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                     _buildTextField(
                                  'Contact', _ContactController, 
                                  keyboard: TextInputType.number,maxLength: 10,minLength: 10),
                                  ],
                                )),
                                const SizedBox(width: 15),
                                 Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text('Email',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                     _buildTextField(
                                  'Email Address', _emailController,
                                  ),
                                  ],
                                )),
                              const SizedBox(width: 15),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text('Pincode',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                  _buildTextField('Pincode', _pincodeController,
                                 
                                  keyboard: TextInputType.number,minLength: 6,maxLength: 6,numbersOnly: true),
                                ],
                              )),
                              const SizedBox(width: 15),
                             Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text('GST Number',style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 5),
                                 _buildTextField('GST Number', _gstController,
                                  regEx: alphanumericNoSpace),
                              ],
                             )),
                              ],
                             ),
                              const SizedBox(height: 30),
                          
                              if (hasProfile)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      isEditable = !isEditable;
                                    });
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: Text(isEditable
                                      ? 'Cancel Edit'
                                      : 'Edit Profile'),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(                            
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ?? false) {
                                await addOrUpdateProfile(hasProfile,
                                    existingId: existingProfileId);
                                  setState(() {
                                      isEditable = false;
                                    });
                                Navigator.of(context).pop();
                              }else {
                                      print("Validation failed");
                                    }
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF); 
                                      },
                                    ),
                                    overlayColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFF1EB386); 
                                        }
                                        return Color(
                                            0xFF1EB386); 
                                      },
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                        Color(0xFF1EB386)),
                                  ),
                                  child: Text("Save")),
                              SizedBox(width: 15.0),
                              ElevatedButton(
                                  onPressed: () {
                                    _NameController.clear();
                                    _AddressController.clear();
                                    _ContactController.clear();
                                    _pincodeController.clear();
                                    Navigator.of(context).pop(context);
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF); 
                                      },
                                    ),
                                    overlayColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFF5B89FF); 
                                        }
                                        return Color(
                                            0xFF5B89FF); 
                                      },
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                        Color(0xFF5B89FF)),
                                  ),
                                  child: Text("Close")),
                            ],
                          ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}

Widget _buildTextField(
    String label, TextEditingController controller, 
    {TextInputType keyboard = TextInputType.text, bool isEditable = true,  RegExp? regEx,int? minLength,
  int? maxLength,
  bool? numbersOnly,}) {
  return TextFormField(
    controller: controller,
    readOnly: !isEditable,
    keyboardType: keyboard,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      filled: !isEditable,
      fillColor: isEditable ? Colors.white : Colors.grey[200],
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$label can\'t be empty';
      }
      if (numbersOnly == true && !RegExp(r'^[0-9]+$').hasMatch(value)) {
        return '$label should contain only numbers';
      }
       if (minLength != null && value.length < minLength) {
        return '$label must be at least $minLength characters';
      }
      if (maxLength != null && value.length > maxLength) {
        return '$label can\'t exceed $maxLength characters';
      }
      if (regEx != null && !regEx.hasMatch(value)) {
          return 'Please enter valid $label';
      }
      return null;
    },
  );
}

Widget _builddropdownField(
    String label, TextEditingController controller, bool isEditable,
    {TextInputType keyboard = TextInputType.text}) {
  return TextFormField(
    controller: controller,
    readOnly: !isEditable,
    keyboardType: keyboard,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      filled: !isEditable,
      fillColor: isEditable ? Colors.white : Colors.grey[200],
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$label can\'t be empty';
      }
      return null;
    },
  );
}
