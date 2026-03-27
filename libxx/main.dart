import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/api.dart';
import 'core/constants.dart';
import 'core/models.dart';
import 'features/auth.dart';
import 'features/customer_screens.dart';
import 'features/rider_screens.dart';
import 'features/extra_screens.dart';
import 'features/review_support_payment_screens.dart';
import 'shared/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(
    ChangeNotifierProvider(create: (_) => CartProvider(), child: const NKApp()),
  );
}

class NKApp extends StatelessWidget {
  const NKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NKsereke',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.secondary, foregroundColor: AppColors.white,
          elevation: 0, centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white),
          iconTheme: IconThemeData(color: AppColors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
          elevation: 0, minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700))),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: AppColors.inputBg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          hintStyle: AppText.cap2.copyWith(color: AppColors.textHint)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white, selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight, elevation: 0,
          type: BottomNavigationBarType.fixed),
        cardTheme: CardTheme(color: AppColors.white, elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border))),
        dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 0),
      ),
      initialRoute: '/splash',
      onGenerateRoute: _router,
    );
  }

  Route<dynamic> _router(RouteSettings s) {
    Widget page;
    switch (s.name) {
      // ── Auth ────────────────────────────────────────────────────────────────
      case '/splash':          page = const SplashScreen();             break;
      case '/login':           page = const LoginScreen();              break;
      case '/signup':          page = const SignupScreen();             break;
      case '/verify-email':    page = const VerifyEmailScreen();        break;
      case '/forgot-password': page = const ForgotPasswordScreen();     break;
      // ── Customer ─────────────────────────────────────────────────────────────
      case '/customer':        page = const CustomerShell();            break;
      case '/vendors':         page = const VendorListScreen();         break;
      case '/vendor-detail':   page = const VendorDetailScreen();       break;
      case '/cart':            page = const CartScreen();               break;
      case '/checkout':        page = const CheckoutScreen();           break;
      case '/order-detail':    page = const CustomerOrderDetailScreen(); break;
      case '/fund-wallet':     page = const FundWalletScreen();         break;
      case '/edit-profile':    page = const EditProfileScreen();        break;
      case '/change-password': page = const ChangePasswordScreen();     break;
      case '/set-pin':         page = const SetPinScreen();             break;
      case '/addresses':       page = const SavedAddressesScreen();     break;
      case '/add-address':     page = const AddAddressScreen();         break;
      case '/notifications':   page = const NotificationsScreen();      break;
      case '/location':        page = const LocationScreen();           break;
      case '/support':         page = const SupportListScreen();        break;
      case '/support/new':     page = const NewSupportTicketScreen();   break;
      case '/support/detail':  page = const SupportTicketDetailScreen(); break;
      case '/write-review':    page = const WriteReviewScreen();        break;
      case '/vendor-reviews':  page = const VendorReviewsScreen();      break;
      case '/payment':         page = const PaymentWebViewScreen();     break;
      // ── Rider ───────────────────────────────────────────────────────────────
      case '/rider':           page = const RiderShell();               break;
      case '/rider-order-detail': page = _RiderOrderDetail(s);         break;
      // ── Fallback ────────────────────────────────────────────────────────────
      default:
        page = Scaffold(body: Center(child: Text('Page not found: ${s.name}')));
    }
    return MaterialPageRoute(builder: (_) => page, settings: s);
  }
}

// ── Rider Order Detail ────────────────────────────────────────────────────────
class _RiderOrderDetail extends StatelessWidget {
  final RouteSettings s;
  const _RiderOrderDetail(this.s);
  @override
  Widget build(BuildContext context) {
    final o = s.arguments as OrderModel?;
    if (o == null) return const Scaffold(body: Loader());
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKBar(title: '#${o.reference}',
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: StatusBadge(status: o.status))]),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('PICKUP FROM', style: AppText.lbl),
          const SizedBox(height: 10),
          Row(children: [
            const LocDot(emoji: '🏪', bg: AppColors.chipBg),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(o.vendor['name'] ?? '', style: AppText.md.copyWith(fontWeight: FontWeight.w700)),
              Text(o.vendor['address'] ?? '', style: AppText.cap2, maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
          ]),
          const SizedBox(height: 14),
          Text('DELIVER TO', style: AppText.lbl),
          const SizedBox(height: 10),
          Row(children: [
            const LocDot(emoji: '🏠', bg: Color(0xFFFFF5E6)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Customer', style: AppText.md.copyWith(fontWeight: FontWeight.w700)),
              if (o.deliveryAddress != null)
                Text(o.deliveryAddress!, style: AppText.cap2, maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
          ]),
        ])),
        NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('FINANCIALS', style: AppText.lbl),
          const SizedBox(height: 10),
          _row('Order Total', fmtPrice(o.total)),
          const Divider(height: 16),
          _row('Delivery Fee', fmtPrice(o.deliveryFee)),
          const Divider(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Your Earning (~80%)', style: AppText.cap),
            Text(fmtPrice((o.deliveryFee * .8).roundToDouble()),
              style: AppText.sub.copyWith(color: AppColors.success, fontSize: 14)),
          ]),
        ])),
        if (o.status == 'picked_up') ...[
          const SizedBox(height: 4),
          NKBtn.green(label: '📦 Mark as Delivered', onTap: () async {
            try {
              await Api().post(Ep.deliverOrder(o.id));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('✅ Delivered! Earnings credited 💰'), backgroundColor: AppColors.success));
                Navigator.pop(context);
              }
            } catch (_) {}
          }),
        ],
        const SizedBox(height: 20),
      ]),
    );
  }
  Widget _row(String l, String v) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(l, style: AppText.cap), Text(v, style: AppText.md.copyWith(fontWeight: FontWeight.w600))]);
}
