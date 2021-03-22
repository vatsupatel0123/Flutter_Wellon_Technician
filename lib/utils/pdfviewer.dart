import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_extend/share_extend.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  final File pdffile;
  const PdfViewerPage({Key key, this.path,this.pdffile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: RichText(
          text: TextSpan(
              text: "Ledger Statement",
              style: GoogleFonts.lato(color: Colors.white,fontSize: 18),
              children: [
                TextSpan(text: "", style: GoogleFonts.lato(color: Colors.green,fontSize: 15))
              ]),
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          InkWell(
            onTap: () async {
//              File testFile = new File(path);
//              if (!await testFile.exists()) {
//                await testFile.create(recursive: true);
//                testFile.writeAsStringSync("test for share documents file");
//              }
              ShareExtend.share(pdffile.path, "file");
            },
            child: Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ],
      ),
      path: path,
    );
  }
}