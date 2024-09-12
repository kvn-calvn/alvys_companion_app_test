import 'dart:async';

import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../network/http_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_document/app_document.dart';
import '../../../utils/app_theme.dart';
import 'package:dio/dio.dart';

import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
//import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_plus/share_plus.dart';

class PDFViewer extends StatefulWidget {
  final AppDocument arguments;

  const PDFViewer({super.key, required this.arguments});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  double progress = 0;
  String errorMessage = '';
  late String path;
  @override
  void initState() {
    super.initState();
    initPdf();
  }

  Future<void> initPdf() async {
    path = "${(await getTemporaryDirectory()).path}/doc.pdf";
    await Dio().download(
      widget.arguments.documentUrl,
      path,
      onReceiveProgress: (count, total) {
        if (mounted) {
          setState(() {
            progress = count / total;
          });
        }
      },
    ).catchError((err) {
      if (mounted) {
        setState(() {
          errorMessage = "Failed to download file.";
          progress = 1;
        });
      }
      return Response(requestOptions: RequestOptions(path: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.arguments.documentType,
          textAlign: TextAlign.start,
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  if (progress < 1) return;
                  await Share.shareXFiles([XFile(path)]);
                  ref.read(httpClientProvider).telemetryClient.trackEvent(
                      name: "share_document", additionalProperties: {"document_type": widget.arguments.documentType});
                  await FirebaseAnalytics.instance
                      .logEvent(name: "share_document", parameters: {"document_type": widget.arguments.documentType});
                },
              );
            },
          )
        ],
      ),
      body: Center(
        child: progress < 1
            ? Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.1,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 16,
                    ),
                  ),
                  progress > 0 ? Text('${(progress * 100).ceil()}') : const SizedBox.shrink(),
                ],
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(errorMessage),
                  )
                : //PdfView(path: path),
                PDFView(filePath: path,)
      ),
    );
  }
}
