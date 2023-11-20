import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_consultancy/models/conversation_model.dart';
import 'package:provider/provider.dart';

import '../../../core/locater.dart';
import '../../../viewmodels/conversation_model.dart';

class ConversationPage extends StatefulWidget {
  final Conversation conversation;
  const ConversationPage({super.key, required this.conversation});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _editionController = TextEditingController();
  final ConversationModel model = getIt<ConversationModel>();
  late final ScrollController _scrollController;
  late FocusNode _focusNode;
  String? url;
  @override
  void initState() {
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: ChangeNotifierProvider(
          create: (BuildContext context) => model,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.conversation.profileImage),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(widget.conversation.name),
                  )
                ],
              ),
              actions: [
                // Padding(
                //     padding: const EdgeInsets.all(4.0),
                //     child: InkWell(onTap: () {}, child: const Icon(Icons.phone_android_outlined))),
                // Padding(
                //     padding: const EdgeInsets.all(4.0),
                //     child: InkWell(onTap: () {}, child: const Icon(Icons.camera_alt_outlined))),
                // Padding(
                //     padding: const EdgeInsets.all(4.0),
                //     child: InkWell(onTap: () {}, child: const Icon(Icons.more_vert_outlined))),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("https://picsum.photos/200/300"))),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: model.getConversation(widget.conversation.id),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView(
                            controller: _scrollController,
                            children: snapshot.data!.docs.map((document) {
                              return ListTile(
                                  title: Align(
                                      alignment: model.currentUser!.uid ==
                                              document['senderId']
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: document['media'] == null ||
                                              document['media']
                                                  .toString()
                                                  .isEmpty
                                          ? Container()
                                          : Column(
                                              children: [
                                                SizedBox(
                                                    width: 150,
                                                    child: Image.network(
                                                        document['media'])),
                                                Text(model
                                                    .formatMessagesTimeStamp(
                                                        document['timeStamp']
                                                            .toDate())),
                                              ],
                                            )),
                                  subtitle: Align(
                                      alignment: model.currentUser!.uid ==
                                              document['senderId']
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: document['message'] == ""
                                          ? const SizedBox()
                                          : Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius: const BorderRadius
                                                      .horizontal(
                                                      left: Radius.circular(10),
                                                      right:
                                                          Radius.circular(10))),
                                              child: Column(
                                                children: [
                                                  Text(
                                                      document['message']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  Text(
                                                      model.formatMessagesTimeStamp(
                                                          document['timeStamp']
                                                              .toDate()),
                                                      style: const TextStyle(
                                                          color: Colors.white))
                                                ],
                                              ))));
                            }).toList(),
                          );
                        }),
                  ),
                  Consumer<ConversationModel>(builder:
                      (BuildContext context, ConversationModel value, child) {
                    return model.uploadedMedia.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                    height: 100,
                                    child: Image.network(model.uploadedMedia))),
                          );
                  }),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(25),
                                right: Radius.circular(25))),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                child: Icon(Icons.tag_faces_outlined),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _editionController,
                                decoration: const InputDecoration(
                                    hintText: "Type a message",
                                    border: InputBorder.none),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                url = await model
                                    .uploadMedia(ImageSource.gallery);
                              },
                              child: Icon(
                                Icons.attach_file_outlined,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  url = await model
                                      .uploadMedia(ImageSource.camera);
                                },
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor),
                        child: IconButton(
                          onPressed: () async {
                            if (_editionController.text.isEmpty) {
                              if (model.uploadedMedia != "") {
                                await model.add({
                                  'senderId': model.currentUser!.uid,
                                  'message': _editionController.text,
                                  'timeStamp': DateTime.now(),
                                  'media': model.uploadedMedia
                                });
                                model.uploadedMedia = "";
                                _editionController.text.isEmpty;
                              }
                            } else {
                              await model.add({
                                'senderId': model.currentUser!.uid,
                                'message': _editionController.text,
                                'timeStamp': DateTime.now(),
                                'media': model.uploadedMedia
                              });
                            }

                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(microseconds: 200),
                                curve: Curves.easeIn);
                            _editionController.text = '';
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
