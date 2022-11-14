import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

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
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String remotePDFPath = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    DefaultCacheManager().getSingleFile(widget.documentPath).then(
          (file) => setState(
            () {
              File pdfDoc = file.renameSync(file.parent.path + '/file.pdf');
              remotePDFPath = pdfDoc.path;
              isLoading = false;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.documentPath);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PdfView(
            path: remotePDFPath,
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
