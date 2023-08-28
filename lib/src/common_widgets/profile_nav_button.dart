import 'package:alvys3/src/common_widgets/avatar.dart';
import 'package:flutter/material.dart';

class ProfileNavButton extends StatelessWidget {
  const ProfileNavButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.profileImageUrl,
  }) : super(key: key);

  final String title;

  final String profileImageUrl;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Avatar(profileImageUrl: profileImageUrl),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(1.0, 0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF95A1AC),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
