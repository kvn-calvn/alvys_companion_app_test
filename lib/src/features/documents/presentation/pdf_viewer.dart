import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
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
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String pdfFlePath = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    createFileOfPdfUrl(widget.documentPath).then((value) => setState(() {
          pdfFlePath = value.path;
          debugPrint('\n\n\n');
          debugPrint(widget.documentPath);
          debugPrint(value.path);
          debugPrint('\n\n\n');
        }));
  }

  Future<File> createFileOfPdfUrl(String docURL) async {
    Completer<File> completer = Completer();
    debugPrint("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = docURL;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      debugPrint("Download files");
      debugPrint("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(widget.documentPath);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentType),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PdfView(path: pdfFlePath),
        ],
      ),
    );
  }
}
