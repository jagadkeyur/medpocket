import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/app_state/AppState.dart';
import 'package:medpocket/src/pages/add_product/index.dart';
import 'package:medpocket/src/pages/add_stockiest/index.dart';
import 'package:medpocket/src/pages/app_init/index.dart';
import 'package:medpocket/src/pages/auth/key_validation/index.dart';
import 'package:medpocket/src/pages/auth/signin/index.dart';
import 'package:medpocket/src/pages/auth/signup/index.dart';
import 'package:medpocket/src/pages/auth/verify/index.dart';
import 'package:medpocket/src/navigation/bottom_navigation/index.dart';
import 'package:medpocket/src/pages/brand_search/index.dart';
import 'package:medpocket/src/pages/cart/index.dart';
import 'package:medpocket/src/pages/center_ads/index.dart';
import 'package:medpocket/src/pages/center_speech/index.dart';
import 'package:medpocket/src/pages/chemist_drugist_search/index.dart';
import 'package:medpocket/src/pages/company_search/index.dart';
import 'package:medpocket/src/pages/company_stockiest/index.dart';
import 'package:medpocket/src/pages/generic_search/index.dart';
import 'package:medpocket/src/pages/news/details.dart';
import 'package:medpocket/src/pages/order/detail.dart';
import 'package:medpocket/src/pages/order/index.dart';
import 'package:medpocket/src/pages/product_list_page/content_details.dart';
import 'package:medpocket/src/pages/product_list_page/details.dart';
import 'package:medpocket/src/pages/product_list_page/index.dart';
import 'package:medpocket/src/pages/stockiest_company/index.dart';
import 'package:medpocket/src/pages/stockiest_details/index.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:in_app_update/in_app_update.dart';

import '../reducers/AppReducer.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  Color primaryColor = const Color(0xff448AFF);
  Color primaryColorDark = const Color(0xff03C988);
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      getOption('primaryColor').then((value) => {
            if (value['data'] != "")
              setState(() {
                primaryColor = Color(int.parse(value['data']));
              })
          });
      getOption('primaryColorDark').then((value) => {
            if (value['data'] != "")
              setState(() {
                primaryColorDark = Color(int.parse(value['data']));
              })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return StoreProvider<AppState>(
      store: store,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: const AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 1,
                colorFilter: ColorFilter.mode(
                    themeData.primaryColor.withOpacity(0.1),
                    BlendMode.lighten))),
        child: MaterialApp(
          navigatorKey: ContextHolder.key,
          theme: ThemeData(
            fontFamily: GoogleFonts.signikaNegative().fontFamily,
            // fontFamily: GoogleFonts.chivoMono().fontFamily,
            primaryColor: primaryColor,
            primaryColorDark: primaryColorDark,
            primaryColorLight: primaryColor.withOpacity(0.5),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const AppInit(),
            '/signin': (context) => const Signin(),
            '/signup': (context) => const Signup(),
            '/verify': (context) => const VerifyOtp(),
            '/key-validate': (context) => const KeyValidation(),
            '/center-ads': (context) => const CenterAdsPage(),
            '/center-speech': (context) => const CenterSpeechPage(),
            '/home': (context) => const BottomNavigation(),
            '/brand-search': (context) => const BrandSearch(),
            '/company-search': (context) => const CompanySearch(),
            '/generic-search': (context) => const GenericSearch(),
            '/company-stockiest': (context) => const CompanyStockiest(),
            '/stockiest-company': (context) => const StockiestCompany(),
            '/stockiest-details': (context) => const StockiestDetails(),
            '/product': (context) => const ProductListPage(),
            '/product-detail': (context) => const ProductDetail(),
            '/product-content': (context) => const ContentDetails(),
            '/cart': (context) => const CartPage(),
            '/chemist-drugist': (context) => const ChemistDrugistSearch(),
            '/orders': (context) => const OrderPage(),
            '/order-details': (context) => const OrderDetailsPage(),
            '/news-details': (context) => const NewsDetailsPage(),
            '/add-stockiest': (context) => const AddStockiest(),
            '/add-product': (context) => const AddProduct(),
          },
        ),
      ),
    );
  }
}
