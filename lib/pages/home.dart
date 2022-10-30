import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/bloc/user/user_bloc.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/tabs/chat.dart';
import 'package:wordpress_app/tabs/conversations_tab.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/tabs/user_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  PageController? _pageController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<IconData> iconList = [
    Feather.home,
    Feather.youtube,
    Feather.search,
    Feather.heart,
    Feather.user
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // AppService().checkInternet().then((hasInternet) {
    //   if (hasInternet!) {
    //     context.read<CategoryBloc>().fetchData();
    //     context.read<MessagesBloc>().getMessages();
    //   } else {
    //     openSnacbar(scaffoldKey, 'no internet'.tr());
    //   }
    // });

    // Future.delayed(Duration(milliseconds: 0)).then((_) {
    //   NotificationService()
    //       .initFirebasePushNotification(context)
    //       .then((_) => context.read<NotificationBloc>().checkSubscription())
    //       .then((_) {
    //     context.read<SettingsBloc>().getPackageInfo();
    //     if (!context.read<UserBloc>().guestUser) {
    //       context.read<UserBloc>().getUserData();
    //     }
    //   });
    // }).then((_) {
    //   // if (AdConfig.isAdsEnabled) {
    //   //   AdConfig()
    //   //       .initAdmob()
    //   //       .then((value) => context.read<AdsBloc>().initiateAds());
    //   // }
    // });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController!.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  Future _onWillPop() async {
    if (selectedIndex != 0) {
      setState(() => selectedIndex = 0);
      _pageController!.animateToPage(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: _bottonNavigationBar(context),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          allowImplicitScrolling: false,
          controller: _pageController,
          children: const <Widget>[
            // HomeTab(),
            // VideoTab(),
            // Chat(),
            // ChatTab(),
            // UserList(),
            // SearchTab(),
            // BookmarkTab(),
            // UserList(),
            Conversations(),
            UserList(),
            UserList(),
            UserList(),
            // SettingPage(),
            // SettingPage(),
            // SettingPage()
          ],
        ),
      ),
    );
  }

  AnimatedBottomNavigationBar _bottonNavigationBar(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: iconList,
      gapLocation: GapLocation.none,
      activeIndex: selectedIndex,
      iconSize: 22,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      inactiveColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: (index) => onItemTapped(index),
    );
  }
}
