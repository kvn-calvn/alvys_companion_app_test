import 'dart:io';

import 'package:alvys3/src/common_widgets/url_nav_button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('About'),
        centerTitle: true,
        elevation: 0,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const UrlNavButton(title: "Alvys", url: "https://alvys.com"),
        const UrlNavButton(
            title: "Terms & Conditions", url: "https://alvys.com/terms/"),
        const UrlNavButton(
            title: "Privacy Policy", url: "https://alvys.com/privacy/"),
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
                            const Text('Device Model: '),
                            Text('${snapshot.data!.utsname.machine}'),
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
                            const Text('Device Model: '),
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
      ]),
    );
  }
}
