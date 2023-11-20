import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/models/detail_model.dart';
import 'package:online_consultancy/screens/sections.dart';
import 'package:online_consultancy/viewmodels/partner_info_edit_model.dart';
import 'package:provider/provider.dart';

import '../core/services/navigator_services.dart';
import '../models/auth_model.dart';
import '../viewmodels/register_model.dart';

class PartnerProfileEdit extends StatefulWidget {
  const PartnerProfileEdit({super.key});
  @override
  State<PartnerProfileEdit> createState() => _PartnerProfileEditState();
}

class _PartnerProfileEditState extends State<PartnerProfileEdit> {
  final List<String> items = [
    'Kişisel Antrenör',
    'Psikolojik Danışman',
    'Diyetisyen',
  ];

  List<dynamic> tagList = [];
  String? selectedValue;
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
    final PartnerInfoModel model = getIt<PartnerInfoModel>();

    return Form(
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
            Partner partner = Partner();
            PartnerDetail partnerDetail = PartnerDetail();
            Future<String> handleAsync() async {
              partner = await model.getPartnerData();
              partnerDetail = await model.getPartnerDetailData();
              selectedValue = partnerDetail.job;
              return Future.value("Success");
            }

            return FutureBuilder<String>(
                future: handleAsync(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: Colors.grey[850],
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_outlined),
                          onPressed: () {
                            _navigatorService.navigateAndRemove(Bolumler());
                          },
                        ),
                        elevation: 0,
                      ),
                      body: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.28,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 35, right: 35),
                                    child: Column(
                                      children: [
                                        _emptyBox(),
                                        ListView(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: [
                                            Text(
                                              "Danisman Profilinizi Düzenleyin",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 33,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            _emptyBox(),
                                            ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: [
                                                Center(
                                                  child: Consumer<
                                                      PartnerInfoModel>(
                                                    builder: (context, model,
                                                        child) {
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          await _choosePhotoDialog(
                                                              context);
                                                          model.notifyWidget();
                                                        },
                                                        child: CircleAvatar(
                                                          child: imageFile !=
                                                                  null
                                                              ? Image.file(
                                                                  imageFile!)
                                                              : Image.network(partner
                                                                              .photoUrl ==
                                                                          null ||
                                                                      partner.photoUrl ==
                                                                          ""
                                                                  ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
                                                                  : partner
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
                                                            text:
                                                                partner.name ??
                                                                    ""),
                                                    labelText: "Name",
                                                    keyboardType:
                                                        TextInputType.name,
                                                    onChanged: (value) {
                                                      partner.name = value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partner
                                                                    .surName ??
                                                                ""),
                                                    labelText: "Surname",
                                                    keyboardType:
                                                        TextInputType.name,
                                                    onChanged: (value) {
                                                      partner.surName = value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text:
                                                                partner.city ??
                                                                    ""),
                                                    labelText: "City",
                                                    keyboardType:
                                                        TextInputType.name,
                                                    onChanged: (value) {
                                                      partner.city = value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partner
                                                                    .officeName ??
                                                                ""),
                                                    labelText: "Office Name",
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onChanged: (value) {
                                                      partner.officeName =
                                                          value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partner
                                                                    .address ??
                                                                ""),
                                                    labelText: "Address",
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onChanged: (value) {
                                                      partner.address = value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text:
                                                                partner.officePhoneNumber ??
                                                                    ""),
                                                    labelText:
                                                        "Office Phone Number",
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    onChanged: (value) {
                                                      partner.officePhoneNumber =
                                                          value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partner
                                                                    .phoneNumber ??
                                                                ""),
                                                    labelText: "Phone Number",
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    onChanged: (value) {
                                                      partner.phoneNumber =
                                                          value;
                                                    },
                                                    validator: (value) {}),
                                              ],
                                            ),
                                            const _emptyBox(),
                                            Column(
                                              children: [
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partnerDetail
                                                                    .education ??
                                                                ""),
                                                    labelText: "Education",
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onChanged: (value) {
                                                      partnerDetail.education =
                                                          value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partnerDetail
                                                                    .areasOfExpertise ??
                                                                ""),
                                                    labelText:
                                                        "Areas of Expertises",
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onChanged: (value) {
                                                      partnerDetail
                                                              .areasOfExpertise =
                                                          value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partnerDetail
                                                                    .certificates ??
                                                                ""),
                                                    labelText: "Certificates",
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onChanged: (value) {
                                                      partnerDetail
                                                          .certificates = value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partnerDetail
                                                                    .detail ??
                                                                ""),
                                                    labelText: "Detail",
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onChanged: (value) {
                                                      partnerDetail.detail =
                                                          value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                _JobDropDownMenu(),
                                                _emptyBox(),
                                                _CustomTextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: partnerDetail
                                                                    .price ??
                                                                ""),
                                                    labelText: "Price",
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
                                                      partnerDetail.price =
                                                          value;
                                                    },
                                                    validator: (value) {}),
                                                _emptyBox(),
                                                Consumer<PartnerInfoModel>(
                                                  builder:
                                                      (context, model, child) {
                                                    partnerDetail.tagList ==
                                                            null
                                                        ? tagList = []
                                                        : tagList =
                                                            partnerDetail
                                                                .tagList!;
                                                    return Column(
                                                      children: [
                                                        Text(
                                                            'Tag Listleriniz:'),
                                                        Container(
                                                          height: 200,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                tagList == null
                                                                    ? 0
                                                                    : tagList
                                                                        .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                title: Text(
                                                                    tagList[
                                                                        index]),
                                                                trailing:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    tagList.removeAt(
                                                                        index);
                                                                    model
                                                                        .notifyWidget();
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .delete_forever_outlined),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                        controller:
                                                                            tagController,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "Ekleyeceginiz Tag List",
                                                                        )),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    tagList.add(
                                                                        tagController
                                                                            .text);
                                                                    tagController
                                                                        .clear();
                                                                    model
                                                                        .notifyWidget();
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .add_box_outlined)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                _emptyBox(),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.blue[700],
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        15)))),
                                                    onPressed: () async {
                                                      partnerDetail.tagList =
                                                          tagList;
                                                      partnerDetail.job =
                                                          selectedValue;
                                                      if (imageFile != null) {
                                                        String? photoUrl = await getIt<
                                                                RegisterModel>()
                                                            .uploadProfileImage(
                                                                imageFile);
                                                        photoUrl ??= "";
                                                        partner.photoUrl =
                                                            photoUrl;
                                                      }
                                                      model.updatePartnerInfo(
                                                        partner: partner,
                                                        partnerDetail:
                                                            partnerDetail,
                                                      );
                                                      _navigatorService
                                                          .navigateAndRemove(
                                                              const Bolumler());
                                                    },
                                                    // ignore: prefer_const_constructors
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              bottom: 15,
                                                              right: 30,
                                                              left: 30),
                                                      child:
                                                          const Text('KAYDET'),
                                                    )),
                                              ],
                                            ),
                                            _emptyBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                });
          },
        ),
      ),
    );
  }

  DropdownButtonHideUnderline _JobDropDownMenu() {
    return DropdownButtonHideUnderline(
      child: Consumer<PartnerInfoModel>(
        builder: (context, model, child) => DropdownButton(
          hint: Text(
            'Lutfen Calismak Istediginiz Bolumu Secin',
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
            selectedValue = value as String;
            model.notifyWidget();
          },
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
