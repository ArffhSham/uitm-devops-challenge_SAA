import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementPreviewScreen extends StatefulWidget {
  final String htmlContent;
  const AgreementPreviewScreen({super.key, required this.htmlContent});

  @override
  State<AgreementPreviewScreen> createState() => _AgreementPreviewScreenState();
}

class _AgreementPreviewScreenState extends State<AgreementPreviewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadHtmlString(widget.htmlContent); // Loads the Dart string as HTML
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rental Agreement Documentation')),
      body: WebViewWidget(controller: _controller),
    );
  }
}