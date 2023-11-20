import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_consultancy/models/auth_model.dart';
import 'package:online_consultancy/screens/login_register/email_verification_page.dart';
import 'package:online_consultancy/screens/login_register/login.dart';

import '../../core/locater.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/navigator_services.dart';
import '../../viewmodels/register_model.dart';

//! Photo URL düzelt

class MemberRegister extends StatefulWidget {
  const MemberRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MemberRegister> {
  Member member = Member();
  late String password;
  final _formKey = GlobalKey<FormState>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final AuthServices _authServices = getIt<AuthServices>();
  File? imageFile;
  RegisterModel model = getIt<RegisterModel>();

  Future<void> addRegister() async {
    if (_formKey.currentState!.validate()) {
      String? photoUrl = await model.uploadProfileImage(imageFile);
      photoUrl ??= "";
      member.photoUrl = photoUrl;
      print(member.email);
      _authServices.createMember(member: member, password: password);
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
        child: Scaffold(
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
                                "Create an\nAccount to\nBecome a\nClient",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 33),
                                textAlign: TextAlign.center,
                              ),
                              const _emptyBox(),
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
                                  member.name = value;
                                },
                                validator: (value) {
                                  return value!.isNotEmpty
                                      ? null
                                      : "Lütfen İsim Giriniz";
                                },
                              ),
                              const _emptyBox(),
                              _CustomTextField(
                                labelText: "Surname",
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  member.surName = value;
                                },
                                validator: (value) {
                                  value!.isNotEmpty
                                      ? null
                                      : "Lütfen Soy isim Giriniz";
                                },
                              ),
                              const _emptyBox(),
                              _CustomTextField(
                                labelText: "Email Adress",
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    member.email = value;
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
                                  member.city = value;
                                },
                                validator: (value) {
                                  value!.isNotEmpty
                                      ? null
                                      : "Lütfen Şehir Giriniz";
                                },
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
                                        onPressed: () {
                                          addRegister();
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
                                    style: const ButtonStyle(),
                                    child: const Text(
                                      'Sign In',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
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
  _CustomTextField({
    Key? key,
    required this.labelText,
    required this.keyboardType,
    this.isObscure = false,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);
  final String labelText;
  final TextInputType keyboardType;
  bool isObscure;
  final onChanged;
  final String? Function(String?) validator;

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
      //next muhbbeti gelcek
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
