import 'package:flutter/material.dart';

class RefreshTutorial extends StatelessWidget {
  final RelativeRect position;
  final RenderBox box;
  const RefreshTutorial({super.key, required this.position, required this.box});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Refresh Button',
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}

class SleepButtonTutorial extends StatelessWidget {
  const SleepButtonTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      right: 0,
      child: Column(
        children: [Text('Refresh Button')],
      ),
    );
  }
}

class ProfileTutorial extends StatelessWidget {
  final RelativeRect position;
  final RenderBox box;
  const ProfileTutorial({super.key, required this.position, required this.box});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + box.size.height,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Profile Button',
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}

class SettingsTutorial extends StatelessWidget {
  final RelativeRect position;
  final RenderBox box;
  const SettingsTutorial({super.key, required this.position, required this.box});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + box.size.height,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Settings Button',
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
