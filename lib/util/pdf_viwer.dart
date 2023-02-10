//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({
    Key key,
    this.pdfUrl,
  }) : super(key: key);
  final String pdfUrl;

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  OverlayEntry _overlayEntry;

  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion.center.dy - 55,
        left: details.globalSelectedRegion.bottomLeft.dx,
        child: TextButton(
          child: const Text('Copy', style: TextStyle(fontSize: 17)),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
        ),
      ),
    );
    _overlayState.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Hero(
        tag: "hero",
        child: Stack(
          children: [
            widget.pdfUrl != null && widget.pdfUrl.isNotEmpty
                ? SfPdfViewer.network(
                    widget.pdfUrl.toString(),
                    // 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                    onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                      if (details.selectedText == null && _overlayEntry != null) {
                        _overlayEntry.remove();
                        _overlayEntry = null;
                      } else if (details.selectedText != null && _overlayEntry == null) {
                        _showContextMenu(context, details);
                      }
                    },
                    controller: _pdfViewerController,
                  )
                : SfPdfViewer.asset(
                    "assets/Use login & password given by admin.pdf",
                    onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                      if (details.selectedText == null && _overlayEntry != null) {
                        _overlayEntry.remove();
                        _overlayEntry = null;
                      } else if (details.selectedText != null && _overlayEntry == null) {
                        _showContextMenu(context, details);
                      }
                    },
                    controller: _pdfViewerController,
                  ),
            Positioned(
              top: 0,
              right: 0,
              // alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            padding: const EdgeInsets.all(5.0),
                            color: Colors.black.withOpacity(0.70),
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 20.0,
                            ))),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
