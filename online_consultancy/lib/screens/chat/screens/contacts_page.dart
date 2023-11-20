import 'package:flutter/material.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/models/profile.dart';

import '../../../viewmodels/contacts_model.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ContactSearchDelegate());
              },
              icon: Icon(Icons.search_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined)),
        ],
      ),
      body: ContactList(),
    );
  }
}

class ContactList extends StatelessWidget {
  final String? query;
  ContactList({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    var model = getIt<ContactsModel>();

    return FutureBuilder(
      future: model.getContacts(query),
      builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error.toString()),
          );
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ListView(
            children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.group_outlined,
                color: Colors.white,
              ),
            ),
            title: Text("New Group"),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.person_add_outlined,
                color: Colors.white,
              ),
            ),
            title: Text("New Contact"),
          ),
        ]..addAll(snapshot.data!
                .map(
                  (Profile) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Icon(Icons.group_outlined, color: Colors.white),
                    ),
                    title: Text("New Group"),
                  ),
                )
                .toList()));
      },
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      primaryColor: Color(0xff075E54),
    );
  }

  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Start searching to chat"),
    );
  }
}
