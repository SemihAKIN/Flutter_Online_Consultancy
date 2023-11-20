import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/models/auth_model.dart';
import 'package:online_consultancy/models/detail_model.dart';
import 'package:online_consultancy/screens/login_register/email_verification_page.dart';
import 'package:online_consultancy/screens/login_register/login.dart';
import 'package:online_consultancy/viewmodels/register_model.dart';
import 'package:provider/provider.dart';

//! Photo URL düzelt

class BusinessPartnerRegister extends StatefulWidget {
  const BusinessPartnerRegister({Key? key}) : super(key: key);

  @override
  _PartnerRegisterState createState() => _PartnerRegisterState();
}

class _PartnerRegisterState extends State<BusinessPartnerRegister> {
  Partner partner = Partner();
  PartnerDetail partnerDetail = PartnerDetail();
  late String password;
  String Job = "Lutfen Calismak Istediginiz Bolumu Secin";
  final _formKey = GlobalKey<FormState>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final AuthServices _authServices = getIt<AuthServices>();
  File? imageFile;
  String? selectedValue;
  RegisterModel model = getIt<RegisterModel>();
  List<dynamic> tagList = [];
  TextEditingController tagController = TextEditingController();

  final List<String> items = [
    'Kişisel Antrenör',
    'Psikolojik Danışman',
    'Diyetisyen',
  ];

  Future<void> addRegister() async {
    if (_formKey.currentState!.validate()) {
      String? photoUrl = await model.uploadProfileImage(imageFile);
      photoUrl ??= "";
      partner.photoUrl = photoUrl;
      User? user = await _authServices.createPartner(
          partner: partner, password: password);
      partnerDetail.id = user!.uid;
      _authServices.addDetailPartner(detail: partnerDetail);
      _navigatorService.navigateTo(const EmailVerificationScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.cover),
        ),
        child: Consumer(
          builder: (context, value, child) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                const Text(
                                  "Create an\nAccount to\nBecome a\nOur Business Partner",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 33),
                                  textAlign: TextAlign.center,
                                ),
                                const _emptyBox(),
                                IconButton(
                                  onPressed: () async {
                                    await _choosePhotoDialog(context);
                                    setState(() {});
                                  },
                                  color: Colors.grey.shade800,
                                  icon: imageFile == null
                                      ? const Icon(
                                          Icons.photo_camera_outlined,
                                        )
                                      : CircleAvatar(
                                          child: Image.file(
                                            imageFile!,
                                          ),
                                        ),
                                  iconSize: 40,
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Name",
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    setState(() {
                                      partner.name = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Surname",
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    setState(() {
                                      partner.surName = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Email Adress",
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    setState(() {
                                      partner.email = value;
                                    });
                                  },
                                  validator: (value) {
                                    return value.toString().contains('@')
                                        ? null
                                        : 'Invalid Mail';
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "City",
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      partner.city = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Address",
                                  keyboardType: TextInputType.streetAddress,
                                  onChanged: (value) {
                                    partner.address = value;
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Phone Number",
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    partner.phoneNumber = value;
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Office Phone Number",
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    partner.officePhoneNumber = value;
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Office Name",
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    partner.officeName = value;
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Areas of Expertise",
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      partnerDetail.areasOfExpertise = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Certificates",
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      partnerDetail.certificates = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Detail",
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      partnerDetail.detail = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Education",
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      partnerDetail.education = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                _JobDropDown(context),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Price",
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      partnerDetail.price = value;
                                    });
                                  },
                                ),
                                const _emptyBox(),
                                Text('Tag Listleriniz:'),
                                Container(
                                  height: 100,
                                  child: ListView.builder(
                                    itemCount: tagList.length,
                                    itemBuilder: (context, index) {
                                      tagList = tagList;
                                      return ListTile(
                                        title: Text(tagList[index]),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                            controller: tagController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  "Ekleyeceginiz Tag List",
                                            )),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (tagController
                                                  .text.isNotEmpty) {
                                                tagList.add(tagController.text);
                                                tagController.clear();
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add_box_outlined)),
                                    ],
                                  ),
                                ),
                                const _emptyBox(),
                                _CustomTextField(
                                  labelText: "Password",
                                  keyboardType: TextInputType.visiblePassword,
                                  isObscure: true,
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                    });
                                  },
                                  validator: (value) {
                                    return value.toString().length > 6
                                        ? null
                                        : 'Too short';
                                  },
                                ),
                                const _emptyBox(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 27,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xff4c505b),
                                      child: IconButton(
                                          color: Colors.white,
                                          onPressed: () async {
                                            if (selectedValue == null) {
                                              Job = "LUTFEN SECIM YAPINIZ";
                                              addRegister();
                                            }
                                            if (selectedValue != null) {
                                              partnerDetail.tagList = tagList;
                                              addRegister();
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                          )),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _navigatorService
                                            .navigateTo(const MyLogin());
                                      },
                                      child: const Text(
                                        'Sign In',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.white,
                                            fontSize: 18),
                                      ),
                                      style: const ButtonStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline _JobDropDown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: Text(
          Job,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
            partnerDetail.job = value;
          });
        },
      ),
    );
  }

  Future<void> _choosePhotoDialog(BuildContext context) async {
    RegisterModel model = getIt<RegisterModel>();
    imageFile = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Galeriden Fotoğraf Seç"),
              onTap: () async {
                await model.getProfileImage(ImageSource.gallery);
                if (model.pickedFile != null) {
                  imageFile = File(model.pickedFile!.path);
                  Navigator.pop(context, imageFile);
                }
              },
            ),
            ListTile(
              title: const Text("Kameradan Fotoğraf Çek"),
              onTap: () async {
                await model.getProfileImage(ImageSource.camera);
                if (model.pickedFile != null) {
                  imageFile = File(model.pickedFile!.path);
                  Navigator.pop(context, imageFile);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _emptyBox extends StatelessWidget {
  const _emptyBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
    );
  }
}

class _CustomTextField extends StatelessWidget {
  _CustomTextField(
      {Key? key,
      required this.labelText,
      required this.keyboardType,
      this.isObscure = false,
      required this.onChanged,
      this.validator})
      : super(key: key);
  final String labelText;
  final TextInputType keyboardType;
  bool isObscure;
  final onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        onChanged(value);
      },
      validator: validator,
      keyboardType: keyboardType,
      obscureText: isObscure,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          labelText: labelText,
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}
