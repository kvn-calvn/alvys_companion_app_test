import 'dart:io';

//import 'package:alvys3/flavor_config.dart';
import 'package:alvys3/src/common_widgets/url_nav_button.dart';
import 'package:alvys3/src/utils/app_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../network/firebase_remote_config_service.dart';
import '../../../network/posthog/posthog_provider.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(postHogProvider).postHogScreen("About", null);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'About',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          // 1
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: AboutPageBody(),
      ),
    );
  }
}

class AboutPageBody extends StatelessWidget {
  const AboutPageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer(builder: (context, ref, child) {
        var alvysURL =
            ref.watch(firebaseRemoteConfigServiceProvider).alvysUrl();
        var alvysTermsUrl =
            ref.watch(firebaseRemoteConfigServiceProvider).alvysTermsUrl();
        var alvysPrivacyUrl =
            ref.watch(firebaseRemoteConfigServiceProvider).alvysPrivacyUrl();

        return Column(children: [
          UrlNavButton(title: "Alvys", url: alvysURL),
          UrlNavButton(title: "Terms", url: alvysTermsUrl),
          UrlNavButton(title: "Privacy Policy", url: alvysPrivacyUrl),
          const SizedBox(
            height: 50.0,
          ),
          Platform.isIOS
              ? FutureBuilder<IosDeviceInfo>(
                  future: DeviceInfoPlugin().iosInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Device: '),
                              Text(snapshot.data!.utsname.machine),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('OS Version: '),
                              Text('${snapshot.data?.systemVersion}'),
                            ],
                          ),
                        ],
                      );
                    }
                    return const Text('no data');
                  },
                )
              : FutureBuilder<AndroidDeviceInfo>(
                  future: DeviceInfoPlugin().androidInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Device: '),
                              Text(
                                  '${snapshot.data!.manufacturer} ${snapshot.data!.model}'),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('OS Version: '),
                              Text('Android ${snapshot.data!.version.release}'),
                            ],
                          ),
                        ],
                      );
                    }
                    return const Text('');
                  },
                ),
          FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                      'App Version: ${snapshot.data!.version} (${snapshot.data!.buildNumber})');
                }

                return const Text('');
              }),
          //Text(FlavorConfig.instance!.flavor.name.toUpperCase()),
        ]);
      }),
    );
  }
}
