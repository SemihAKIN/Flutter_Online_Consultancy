import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';

import '../../core/locater.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController controller = TextEditingController();
  final AuthServices _authServices = getIt<AuthServices>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şifre Sıfırlama"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          const Text("Lütfen e-posta adresinizi girin!"),
          TextField(controller: controller),
          TextButton(
              onPressed: () {
                _authServices.resetPassword(controller.text);
                controller.clear();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Şifre Sıfırlama'),
                      content: const Text(
                          'Şifre Sıfırlama için e-postanıza gelen bağlantıyı kontrol edin!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Onayla'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Gönder"))
        ],
      )),
    );
  }
}
