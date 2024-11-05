import '../utils/app_theme.dart';
import 'package:flutter/material.dart';

class RefreshablePage extends StatelessWidget {
  final String title;
  final Future<void> Function() refresh;
  final Widget Function() body;
  const RefreshablePage({super.key, required this.title, required this.refresh, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 18.0, left: 5.0),
            constraints: const BoxConstraints(),
            onPressed: () async {
              await refresh();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: RefreshIndicator(
          onRefresh: refresh,
          child: body(),
        ),
      ),
    );
  }
}
