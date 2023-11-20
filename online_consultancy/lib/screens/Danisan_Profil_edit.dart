import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/screens/sections.dart';
import 'package:online_consultancy/viewmodels/member_info_edit_model.dart';
import 'package:provider/provider.dart';

import '../core/services/navigator_services.dart';
import '../models/auth_model.dart';
import '../viewmodels/register_model.dart';

class MemberProfileEdit extends StatefulWidget {
  const MemberProfileEdit({super.key});
  @override
  State<MemberProfileEdit> createState() => _MemberProfileEditState();
}

class _MemberProfileEditState extends State<MemberProfileEdit> {
  File? imageFile;

  Future<void> _choosePhotoDialog(BuildContext context) async {
    RegisterModel registerModel = getIt<RegisterModel>();
    imageFile = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Galeriden Fotoğraf Seç"),
              onTap: () async {
                await registerModel.getProfileImage(ImageSource.gallery);
                if (registerModel.pickedFile != null) {
                  imageFile = File(registerModel.pickedFile!.path);
                  Navigator.pop(context, imageFile);
                }
              },
            ),
            ListTile(
              title: const Text("Kameradan Fotoğraf Çek"),
              onTap: () async {
                await registerModel.getProfileImage(ImageSource.camera);
                if (registerModel.pickedFile != null) {
                  imageFile = File(registerModel.pickedFile!.path);
                  Navigator.pop(context, imageFile);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController tagController = TextEditingController();
    final NavigatorService _navigatorService = getIt<NavigatorService>();
    final MemberInfoModel model = getIt<MemberInfoModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/register.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ChangeNotifierProvider(
                create: (context) => model,
                builder: (context, child) {
                  Member member = Member();
                  Future<String> handleAsync() async {
                    member = await model.getMemberData();
                    return Future.value("Success");
                  }

                  return FutureBuilder<String>(
                      future: handleAsync(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: AppBar(
                                backgroundColor: Colors.grey[850],
                                leading: IconButton(
                                  icon: const Icon(Icons.arrow_back_outlined),
                                  onPressed: () {
                                    _navigatorService
                                        .navigateAndRemove(const Bolumler());
                                  },
                                ),
                                elevation: 0,
                              ),
                              body: Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.28,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 35, right: 35),
                                            child: Column(
                                              children: [
                                                _emptyBox(),
                                                ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Text(
                                                      "Profilinizi Düzenleyin",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 33,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    _emptyBox(),
                                                    ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      children: [
                                                        Center(
                                                          child: Consumer<
                                                              MemberInfoModel>(
                                                            builder: (context,
                                                                model, child) {
                                                              return GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await _choosePhotoDialog(
                                                                      context);
                                                                  model
                                                                      .notifyWidget();
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  child: imageFile !=
                                                                          null
                                                                      ? Image.file(
                                                                          imageFile!)
                                                                      : Image.network(member.photoUrl == null ||
                                                                              member.photoUrl ==
                                                                                  ""
                                                                          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
                                                                          : member
                                                                              .photoUrl!),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const _emptyBox(),
                                                    Column(
                                                      children: [
                                                        _emptyBox(),
                                                        _CustomTextField(
                                                            controller:
                                                                TextEditingController(
                                                                    text: member
                                                                        .name),
                                                            labelText: "Name",
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            onChanged: (value) {
                                                              member.name =
                                                                  value;
                                                            },
                                                            validator:
                                                                (value) {}),
                                                        _emptyBox(),
                                                        _CustomTextField(
                                                            controller:
                                                                TextEditingController(
                                                                    text: member
                                                                        .surName),
                                                            labelText:
                                                                "Surname",
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            onChanged: (value) {
                                                              member.surName =
                                                                  value;
                                                            },
                                                            validator:
                                                                (value) {}),
                                                        _emptyBox(),
                                                        _CustomTextField(
                                                            controller:
                                                                TextEditingController(
                                                                    text: member
                                                                        .city),
                                                            labelText: "City",
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            onChanged: (value) {
                                                              member.city =
                                                                  value;
                                                            },
                                                            validator:
                                                                (value) {}),
                                                      ],
                                                    ),
                                                    const _emptyBox(),
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.blue[
                                                                    700],
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)))),
                                                        onPressed: () async {
                                                          if (imageFile !=
                                                              null) {
                                                            String? photoUrl = await getIt<
                                                                    RegisterModel>()
                                                                .uploadProfileImage(
                                                                    imageFile);
                                                            photoUrl ??= "";
                                                            member.photoUrl =
                                                                photoUrl;
                                                          }
                                                          model
                                                              .updateMemberInfo(
                                                            member: member,
                                                          );
                                                          _navigatorService
                                                              .navigateAndRemove(
                                                                  const Bolumler());
                                                        },
                                                        // ignore: prefer_const_constructors
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 15,
                                                                  bottom: 15,
                                                                  right: 30,
                                                                  left: 30),
                                                          child: const Text(
                                                              'KAYDET'),
                                                        )),
                                                  ],
                                                ),
                                                _emptyBox(),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        }
                      });
                }),
          )),
    );
  }
}

class _emptyBox extends StatelessWidget {
  const _emptyBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    required this.controller,
  }) : super(key: key);
  final String labelText;
  final TextInputType keyboardType;
  TextEditingController controller;
  bool isObscure;
  final onChanged;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
