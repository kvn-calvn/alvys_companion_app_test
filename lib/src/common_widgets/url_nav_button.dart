import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/http_client.dart';
import '../network/posthog/posthog_provider.dart';

class UrlNavButton extends StatelessWidget {
  const UrlNavButton({
    super.key,
    required this.title,
    required this.url,
  });

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
        child: Ink(child: Consumer(
          builder: (context, ref, child) {
            return InkWell(
              onTap: () async {
                if (!await launchUrl(_url)) {
                  throw 'Could not launch $_url';
                }
                ref.read(postHogProvider).postHogTrackEvent(
                    "${title.replaceAll(' ', '').toLowerCase()}_button_tapped",
                    null);
                ref.read(httpClientProvider).telemetryClient.trackEvent(
                    name: "${title.replaceAll(' ', '')}_button_tapped");
                await FirebaseAnalytics.instance.logEvent(
                    name: "${title.replaceAll(' ', '')}_button_tapped");
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
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
            );
          },
        )),
      ),
    );
  }
}
