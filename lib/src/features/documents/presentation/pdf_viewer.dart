import 'dart:async';
import 'dart:io';

import 'package:alvys3/src/constants/text_styles.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/color.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer(
      {Key? key, required this.documentPath, required this.documentType})
      : super(key: key);

  final String documentPath;
  final String documentType;

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  double progress = 0;
  late String path;
  @override
  void initState() {
    super.initState();
    initPdf();
  }

  Future<void> initPdf() async {
    path = "${(await getTemporaryDirectory()).path}/doc.pdf";
    await Dio().download(
      widget.documentPath,
      path,
      onReceiveProgress: (count, total) {
        if (mounted) {
          setState(() {
            progress = count / total;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.documentType,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.titleMedium,
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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              if (progress < 1) return;
              await Share.shareXFiles([XFile(path)]);
            },
          ),
        ],
      ),
      body: Center(
        child: progress < 1
            ? SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: progress,
                ),
              )
            : PdfView(path: path),
      ),
    );
  }
}
