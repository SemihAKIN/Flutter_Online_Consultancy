import 'package:flutter/material.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/screens/chat/screens/camera_page.dart';
import 'package:online_consultancy/screens/chat/screens/chats_page.dart';
import 'package:online_consultancy/viewmodels/main_model.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _showmessage = true;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4, initialIndex: 1);
    _tabController.addListener(() {
      _showmessage = _tabController.index != 0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = getIt<MainModel>();

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  title: Text("Chats"),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.search_outlined)),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
                  ],
                )
              ];
            },
            body: Column(
              children: [
                TabBar(controller: _tabController, tabs: const <Widget>[
                  Tab(
                    icon: Icon(Icons.camera_alt_outlined),
                  ),
                  Tab(text: "Chats"),
                  Tab(text: "Status"),
                  Tab(text: "Calls")
                ]),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          CameraPage(),
                          ChatsPage(),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _showmessage
          ? FloatingActionButton(
              onPressed: () async {
                await model.navigateToContacts();
              },
              child: const Icon(
                Icons.message_outlined,
              ),
            )
          : null,
    );
  }
}
