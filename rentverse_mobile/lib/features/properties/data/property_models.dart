import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementViewerScreen extends StatefulWidget {
  final String htmlContent;
  const AgreementViewerScreen({super.key, required this.htmlContent});

  @override
  State<AgreementViewerScreen> createState() => _AgreementViewerScreenState();
}

class _AgreementViewerScreenState extends State<AgreementViewerScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadHtmlString(widget.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agreement Documentation')),
      body: WebViewWidget(controller: _controller),
    );
  }
}