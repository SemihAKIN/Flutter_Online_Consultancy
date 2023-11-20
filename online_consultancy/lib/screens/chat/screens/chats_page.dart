import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:online_consultancy/models/chat_model.dart';
import 'package:provider/provider.dart';

import '../../../core/locater.dart';
import '../../../core/services/auth_service.dart';
import '../../../models/conversation_model.dart';
import 'conversation_page.dart';

class ChatsPage extends StatelessWidget {
  final AuthServices _authService = getIt<AuthServices>();
  ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatsModel model = GetIt.instance<ChatsModel>();
    return ChangeNotifierProvider(
      create: (BuildContext context) => model,
      child: StreamBuilder<List<Conversation>>(
        stream: model.conversations(_authService.currentUser!.uid),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return Scaffold(
            body: ListView(
                children: snapshot.data!
                    .map((doc) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(doc.profileImage),
                          ),
                          title: Text(doc.name),
                          subtitle: Text(doc.displayMessage),
                          trailing: Column(
                            children: [
                              const Text(""),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                child: const Center(
                                  child: Text(
                                    "16",
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConversationPage(
                                          conversation: doc,
                                        )));
                          },
                        ))
                    .toList()),
          );
        },
      ),
    );
  }
}
