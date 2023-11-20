import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/screens/entry_screen.dart';
import 'package:online_consultancy/screens/login_register/type_selection.dart';
import 'package:online_consultancy/screens/sections.dart';
import 'package:online_consultancy/viewmodels/login_model.dart';
import 'package:provider/provider.dart';

import 'forgot_password.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late String email, password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<LoginModel>(),
      child: Consumer<LoginModel>(
        builder: (context, model, child) {
          return model.busy
              ? const Center(child: CircularProgressIndicator())
              : Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    elevation: 0,
                    title: const Text('Login'),
                    leading: IconButton(
                      onPressed: () =>
                          model.navigatorService.navigateTo(EntryScreen()),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  body: Form(
                    key: formKey,
                    child: Stack(children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/login.png'),
                              fit: BoxFit.cover),
                        ),
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Stack(
                            children: [
                              Container(),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 35, top: 100),
                                child: const Text(
                                  'Welcome\nBack',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 33),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 35, right: 35),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              validator: (value) {
                                                return value
                                                        .toString()
                                                        .contains('@')
                                                    ? null
                                                    : 'Invalid Email';
                                              },
                                              onChanged: (value) {
                                                email = value;
                                              },
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  fillColor:
                                                      Colors.grey.shade100,
                                                  filled: true,
                                                  hintText: "Email",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                return value.toString().length >
                                                        6
                                                    ? null
                                                    : 'Too Short';
                                              },
                                              onChanged: (value) {
                                                password = value;
                                              },
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              style: const TextStyle(),
                                              obscureText: true,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  fillColor:
                                                      Colors.grey.shade100,
                                                  filled: true,
                                                  hintText: "Password",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Sign in',
                                                  style: TextStyle(
                                                      fontSize: 27,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      const Color(0xff4c505b),
                                                  child: IconButton(
                                                      color: Colors.white,
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          String validateCode =
                                                              await model
                                                                  .signIn(email,
                                                                      password);
                                                          switch (
                                                              validateCode) {
                                                            case 'valid':
                                                              _navigatorService
                                                                  .navigateTo(
                                                                      const Bolumler());
                                                              break;
                                                            case 'invalid-email':
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "E-mail Yanlış",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);

                                                              break;
                                                            case 'user-not-found':
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Kullanıcı bulunamadı",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);

                                                              break;
                                                            case 'wrong-password':
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Yanlış Şifre",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);

                                                              break;
                                                            default:
                                                          }
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () async => await model
                                                      .navigatorService
                                                      .navigateTo(
                                                          const TypeSelection()),
                                                  style: const ButtonStyle(),
                                                  child: const Text(
                                                    'Sign Up',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color:
                                                            Color(0xff4c505b),
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      model.navigatorService
                                                          .navigateTo(
                                                              const ForgotPasswordPage());
                                                    },
                                                    child: const Text(
                                                      'Forgot Password',
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color:
                                                            Color(0xff4c505b),
                                                        fontSize: 18,
                                                      ),
                                                    )),
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
                          ),
                        ),
                      )
                    ]),
                  ));
        },
      ),
    );
  }
}
