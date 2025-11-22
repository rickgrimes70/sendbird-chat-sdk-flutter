// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:testing/notifications/local_notifications_manager.dart';
import 'package:testing/notifications/push_manager.dart';
import 'package:testing/page/channel/feed_channel/feed_channel_list_page.dart';
import 'package:testing/page/channel/feed_channel/feed_channel_page.dart';
import 'package:testing/page/channel/group_channel/group_channel_create_page.dart';
import 'package:testing/page/channel/group_channel/group_channel_invite_page.dart';
import 'package:testing/page/channel/group_channel/group_channel_list_page.dart';
import 'package:testing/page/channel/group_channel/group_channel_page.dart';
import 'package:testing/page/channel/group_channel/group_channel_search_page.dart';
import 'package:testing/page/channel/group_channel/group_channel_send_file_message_page.dart';
import 'package:testing/page/channel/group_channel/group_channel_update_page.dart';
import 'package:testing/page/channel/open_channel/open_channel_create_page.dart';
import 'package:testing/page/channel/open_channel/open_channel_list_page.dart';
import 'package:testing/page/channel/open_channel/open_channel_page.dart';
import 'package:testing/page/channel/open_channel/open_channel_search_page.dart';
import 'package:testing/page/channel/open_channel/open_channel_update_page.dart';
import 'package:testing/page/login_page.dart';
import 'package:testing/page/main_page.dart';
import 'package:testing/page/message/message_update_page.dart';
import 'package:testing/page/user/user_nickname_update_page.dart';
import 'package:testing/page/user/user_page.dart';
import 'package:testing/page/user/user_profile_update_page.dart';
import 'package:testing/utils/app_prefs.dart';

const sampleVersion = '4.7.0';
const yourAppId = '05EDCA18-76C4-481C-9910-1F726F0BD94C';
//'728E8736-5D0C-47CE-B934-E39B656900F3';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (errorDetails) {
        debugPrint('[FlutterError] ${errorDetails.stack}');
        Fluttertoast.showToast(
          msg: '[FlutterError] ${errorDetails.stack}',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
        );
      };

      await PushManager.initialize();
      await LocalNotificationsManager.initialize();
      await AppPrefs().initialize();

      runApp(const MyApp());
    },
    (error, stackTrace) async {
      debugPrint('[Error] $error\n$stackTrace');
      Fluttertoast.showToast(
        msg: '[Error] $error',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sendbird Chat Sample',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: _createMaterialColor(
          const Color.fromARGB(196, 90, 24, 196),
        ),
      ),
      builder: (context, child) {
        return ScrollConfiguration(behavior: _AppBehavior(), child: child!);
      },
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
        ),
        GetPage(
          name: '/main',
          page: () => const MainPage(),
        ),
        GetPage(
          name: '/user',
          page: () => const UserPage(),
        ),
        GetPage(
          name: '/user/update/profile',
          page: () => const UserProfileUpdatePage(),
        ),
        GetPage(
          name: '/user/update/nickname',
          page: () => const UserNicknameUpdatePage(),
        ),
        GetPage(
          name: '/group_channel/list',
          page: () => const GroupChannelListPage(),
        ),
        GetPage(
          name: '/group_channel/search',
          page: () => const GroupChannelSearchPage(),
        ),
        GetPage(
          name: '/group_channel/create',
          page: () => const GroupChannelCreatePage(),
        ),
        GetPage(
          name: '/group_channel/update/:channel_url',
          page: () => const GroupChannelUpdatePage(),
        ),
        GetPage(
          name: '/group_channel/invite/:channel_url',
          page: () => const GroupChannelInvitePage(),
        ),
        GetPage(
          name: '/group_channel/:channel_url',
          page: () => const GroupChannelPage(),
        ),
        GetPage(
          name: '/group_channel/send_file_message/:channel_url',
          page: () => const GroupChannelSendFileMessagePage(),
        ),
        GetPage(
          name: '/open_channel/list',
          page: () => const OpenChannelListPage(),
        ),
        GetPage(
          name: '/open_channel/search',
          page: () => const OpenChannelSearchPage(),
        ),
        GetPage(
          name: '/open_channel/create',
          page: () => const OpenChannelCreatePage(),
        ),
        GetPage(
          name: '/open_channel/update/:channel_url',
          page: () => const OpenChannelUpdatePage(),
        ),
        GetPage(
          name: '/open_channel/:channel_url',
          page: () => const OpenChannelPage(),
        ),
        GetPage(
          name: '/message/update/:channel_type/:channel_url/:message_id',
          page: () => const MessageUpdatePage(),
        ),
        GetPage(
          name: '/feed_channel/list',
          page: () => const FeedChannelListPage(),
        ),
        GetPage(
          name: '/feed_channel/:channel_url',
          page: () => const FeedChannelPage(),
        ),
      ],
    );
  }

  MaterialColor _createMaterialColor(Color color) {
    final int r = color.red, g = color.green, b = color.blue;
    final strengths = <double>[.05];
    final Map<int, Color> swatch = {};

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class _AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

// import 'package:flutter/material.dart';
// import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
// import 'package:testing/utils/user_prefs.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     start();
//     super.initState();
//   }

//   void start() async {
//     await SendbirdChat.init(
//       appId: //'//769D3782-C889-467F-92D7-FA607D98C80E',
//           '05EDCA18-76C4-481C-9910-1F726F0BD94C',
//       // options: SendbirdChatOptions(
//       //   useCollectionCaching: useCollectionCaching,
//       // ),
//     );

//     var user = await SendbirdChat.connect('cb_test001',
//         accessToken: '3ae23d0857342d5bcd4a1caa5fe3c77caf159cb1',
//         apiHost:
//             'https://api-05EDCA18-76C4-481C-9910-1F726F0BD94C.sendbird.com/v3/',
//         wsHost: 'wss://ws-05EDCA18-76C4-481C-9910-1F726F0BD94C.sendbird.com');

//     // var session = SendbirdChat.getSessionHandler();
//     // print(session);

//     // var pendingPushToken = SendbirdChat.getPendingPushToken();
//     // // await SendbirdChat.connect(userId);
//     // var currentUser = SendbirdChat.currentUser;

//     // print("sendbird>>>$sendbird");
//     // print("user>>>${user.toJson()}");
//     // print("pendingPushToken>>>$pendingPushToken");
//     // print("currentUser>>>${currentUser?.toJson()}");
//     // var sh = SendbirdChat.getSessionHandler();
//     // print("session>>>${sh.toString()}");

//     // await UserPrefs.setLoginUserId();
//     // var loginID = await UserPrefs.getLoginUserId();

//     // print("loginID>>>$loginID");
//     // var s = SendbirdChat.getSessionHandler();
//     // print("ses>>>>>$s");
//     print("user>>>${user.toJson()}");
//     print("session key>>>${user.chat.chatContext.sessionKey}");

//     //final sessionToken = await SendbirdChat.generateSessionToken();
//     // await SendbirdChat.connect(userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(onPressed: start, child: const Text('Sendbird'))
//           ],
//         ),
//       ),
//     );
//   }
// }
