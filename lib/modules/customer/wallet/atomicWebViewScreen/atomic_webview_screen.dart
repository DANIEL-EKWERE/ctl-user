import 'package:atomic_webview/atomic_webview.dart';
import 'package:ctluser/modules/customer/home/customer_home_controller.dart';
import 'package:ctluser/routes/app_routes.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:ctluser/core/utils/toast.dart';

//WalletController walletController = Get.put(WalletController());

class AtomicWebViewScreen extends StatefulWidget {
  AtomicWebViewScreen({super.key, this.url = ''});

  final String? url;

  @override
  State<AtomicWebViewScreen> createState() => _AtomicWebViewScreenState();
}

class _AtomicWebViewScreenState extends State<AtomicWebViewScreen> {
  WebViewController webViewController = WebViewController();
  InAppWebViewController? webViewController1;
  final String callback_url = "https://nksereke.com";
  final String callback_url2 = "https://nksereke.com/api";
  final String callback_url3 = "nksereke://payment/result";

  final ctrl = CustomerHomeController.to;
  bool isLoading = true;
  int progress = 0;
  String status = 'Loading...';

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var url = widget.url ?? '';

    //   Loggerr.log("Paystack URL in webview page: $url");

    //   webViewController.init(
    //     context: context,
    //     setState: setState,
    //     uri: Uri.parse(url),
    //   );
    // });
  }

  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).canPop()
                ? Navigator.pop(context)
                : Navigator.of(context).pushNamed(AppRoutes.customerShell);
          },
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        title: const Text(
          'Complete Payment',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).canPop()
                  ? Navigator.pop(context)
                  : Navigator.of(context).pushNamed(AppRoutes.customerShell);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(widget.url ?? '')),
            onWebViewCreated: (controller) {
              webViewController1 = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
                status = 'Loading ${url?.toString() ?? ''}';
              });
            },
            onProgressChanged: (controller, newProgress) {
              setState(() {
                progress = newProgress;
                status = 'Loading... $progress%';
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
                progress = 100;
                status = 'Loaded ${url?.toString() ?? ''}';
              });

              final urlStr = url?.toString() ?? '';

              // Paystack cancelled — close webview and show message
              if (urlStr.contains('paystack') &&
                  (urlStr.contains('cancel') || urlStr.contains('close'))) {
                if (Navigator.of(context).canPop()) Navigator.pop(context);
                showToast('Payment cancelled.');
                return;
              }

              // Successful callback — wallet funded
              if (urlStr.startsWith(callback_url) ||
                  urlStr.startsWith(callback_url2) ||
                  urlStr.startsWith(callback_url3)) {
                if (Navigator.of(context).canPop()) Navigator.pop(context);
                ctrl.loadWallet();
                showToast('Wallet funded successfully!');
              }
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                isLoading = false;
                status = 'Error loading page: $message';
              });
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text('Load failed: $message')));
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(value: progress / 100),
                    SizedBox(height: 12),
                    Text(status, style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    // return WebView(
    //   controller: webViewController,
    // );
  }
}
