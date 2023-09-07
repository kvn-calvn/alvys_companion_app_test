import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlNavButton extends StatelessWidget {
  const UrlNavButton({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String title;
  final String url;
  Uri get _url => Uri.parse(url);
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
            onTap: () async {
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF95A1AC),
                    size: 18,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
