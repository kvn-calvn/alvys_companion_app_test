import 'package:flutter/material.dart';

import '../../common_widgets/empty_view.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
        centerTitle: false,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: NotificationList(),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const EmptyView(title: "No updates", description: "Trip update notifications will appear here.");
  }
}
