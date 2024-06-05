import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class PdfViewerPage extends StatefulWidget {
 
  final String url;
  PdfViewerPage(this.url, {Key key }): super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String localPath;
  @override
  void initState() {
    super.initState();
    loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POLITICAS DE PRIVACIDAD",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

   

  Future<String> loadPDF() async {
    var response = await http.get(Uri.parse(widget.url));
    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/politicas.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

}
