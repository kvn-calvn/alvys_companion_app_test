import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.profileImageUrl,
  });

  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 60,
        height: 60,
        child: ClipOval(
          child: Image.network(
            profileImageUrl,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.warning_rounded),
          ),
        ),
      ),
    );
  }
}
