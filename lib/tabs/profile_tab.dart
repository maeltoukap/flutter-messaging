import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/bloc/notifications/notifications_bloc.dart';
import 'package:wordpress_app/bloc/setting/settings_bloc.dart';
import 'package:wordpress_app/bloc/theme/theme_bloc.dart';
import 'package:wordpress_app/bloc/user/user_bloc.dart';
import 'package:wordpress_app/configs/configs.dart';
import 'package:wordpress_app/pages/welcome.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/utils/navigation.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  void openLicenceDialog() {
    final SettingsBloc sb =
        BlocProvider.of<SettingsBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (_) {
          return AboutDialog(
            applicationName: Config.appName,
            applicationVersion: sb.appVersion,
            applicationIcon: const Image(
              image: const AssetImage(Config.appIcon),
              height: 30,
              width: 30,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ub = context.watch<UserBloc>();
    context.watch<NotificationsBloc>().checkSubscription();
    context.watch<ThemeBloc>().loadFromPrefs();
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 140,
          pinned: true,
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            title: const Text('settings',
                    style: const TextStyle(color: Colors.white))
                .tr(),
            titlePadding:
                const EdgeInsets.only(left: 20, bottom: 20, right: 20),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary),
                    child: !ub.isSignedIn ? GuestUserUI() : UserUI()),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'general settings',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                            wordSpacing: 1),
                      ).tr(),
                      const SizedBox(height: 15),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: const Icon(
                            Feather.bell,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'get notifications',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Switch(
                            activeColor: Theme.of(context).primaryColor,
                            value:
                                context.watch<NotificationsBloc>().subscribed!,
                            onChanged: (bool value) => context
                                .read<NotificationsBloc>()
                                .configureFcmSubscription(value)),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 18,
                          child: const Icon(
                            Icons.wb_sunny,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'dark mode',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Switch(
                            activeColor: Theme.of(context).primaryColor,
                            value: context.watch<ThemeBloc>().darkTheme!,
                            onChanged: (bool) {
                              context.read<ThemeBloc>().toggleTheme();
                            }),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.purpleAccent,
                          radius: 18,
                          child: const Icon(
                            Feather.globe,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'language',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => nextScreenPopup(context, LanguagePopup()), //TODO: change this
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'about app',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                            wordSpacing: 1),
                      ).tr(),
                      const SizedBox(height: 15),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 18,
                          child: const Icon(
                            Feather.lock,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'privacy policy',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => AppService().openLinkWithCustomTab( //TODO: change this
                        //     context, Config.privacyPolicyUrl),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.pinkAccent,
                          radius: 18,
                          child: const Icon(
                            Feather.star,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'rate this app',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => AppService().launchAppReview(context), //TODO: change this
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          radius: 18,
                          child: const Icon(
                            Feather.lock,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'licence',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        onTap: () => openLicenceDialog(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'social settings',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                            wordSpacing: 1),
                      ).tr(),
                      const SizedBox(height: 15),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent[100],
                          radius: 18,
                          child: const Icon(
                            Feather.mail,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'contact us',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => AppService().openEmailSupport(), //TODO: change this
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: const Icon(
                            Feather.link,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'our website',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => AppService().openLinkWithCustomTab( //TODO: change this
                        //     context, WpConfig.websiteUrl),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 18,
                          child: const Icon(
                            Feather.facebook,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'facebook page',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => AppService()
                        //     .openLink(context, Config.facebookPageUrl), //TODO: change this
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 18,
                          child: const Icon(
                            Feather.youtube,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'youtube channel',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => AppService()
                        //     .openLink(context, Config.youtubeChannelUrl), //TODO: change this
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 18,
                          child: const Icon(
                            Feather.twitter,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'twitter',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        // onTap: () => AppService()
                        //     .openLink(context, Config.twitterUrl), //TODO: change this
                      ),
                    ],
                  ),
                ),

                //BuyNowWidget(),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      thickness: 0.2,
      indent: 50,
      color: Colors.grey[400],
    );
  }
}

class GuestUserUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: const Icon(
              Feather.user_plus,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'login',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ).tr(),
          trailing: const Icon(Feather.chevron_right),
          // onTap: () => nextScreenPopup( //TODO: change this
          //     context,
          //     LoginPage(
          //       popUpScreen: true,
          //     )),
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().getUserData();
    final UserBloc ub = context.read<UserBloc>();
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: const Icon(
              Feather.user_check,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.name!,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const _Divider(),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent[100],
            radius: 18,
            child: const Icon(
              Feather.mail,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.email!,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const _Divider(),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent[100],
            radius: 18,
            child: const Icon(
              Feather.log_out,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'logout',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ).tr(),
          trailing: const Icon(Feather.chevron_right),
          onTap: () => openLogoutDialog(context),
        ),
      ],
    );
  }

  openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('logout description').tr(),
            title: const Text('logout title').tr(),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _handleLogout(context); //TODO: change this
                  },
                  child: const Text('logout').tr()),
            ],
          );
        });
  }

  Future _handleLogout(context) async {
    final UserBloc ub = BlocProvider.of<UserBloc>(context, listen: false);
    await ub
        .userSignout()
        .then((value) => nextScreenCloseOthers(context, WelcomePage()));
  }
}

String _userName = "";
String _email = "";
Future getUserData() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  _userName = sp.getString('user_name')!;
  _email = sp.getString('email')!;
  // notifyListeners();
}
