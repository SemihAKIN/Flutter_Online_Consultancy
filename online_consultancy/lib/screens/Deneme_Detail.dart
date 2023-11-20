import 'package:flutter/material.dart';

import '../core/locater.dart';
import '../core/services/navigator_services.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final NavigatorService _navigatorService = getIt<NavigatorService>();
    return Form(
        child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/register.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              //  ----- >>>>>>>  _navigatorService.navigateAndRemove(Bolumler());
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
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Text(
                                "Danisman Profilinizi Düzenleyin",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 33,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 40),
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Center(
                                    child: CircleAvatar(),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.photo_camera_outlined),
                                    color: Colors.grey.shade800,
                                    iconSize: 40,
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              _AllTextFields()
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Column _AllTextFields() {
    return Column(
      children: [
        _CustomTextFormField(
            labelText: "Email",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {
              return value.toString().contains('@') ? null : 'Invalid Mail';
            }),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Office Name",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Office Adress",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Office Phone Number",
            keyboardType: TextInputType.phone,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Phone Number",
            keyboardType: TextInputType.phone,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Areas of Experties",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Certificates",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Detail",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Job",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Price",
            keyboardType: TextInputType.number,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        _CustomTextFormField(
            labelText: "Tag List",
            keyboardType: TextInputType.text,
            onChanged: () {},
            validator: (value) {}),
        SizedBox(height: 40),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            onPressed: () {},
            // ignore: prefer_const_constructors
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, right: 30, left: 30),
              child: const Text('KAYDET'),
            )),
        SizedBox(height: 40)
      ],
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  _CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.keyboardType,
    this.isObscure = false,
    required this.onChanged,
    required this.validator,
  }) : super();
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
            )));
  }
}
