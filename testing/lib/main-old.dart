import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    start();
    super.initState();
  }

  void start() async {
    var sendbird = await SendbirdChat.init(
      appId: //'//769D3782-C889-467F-92D7-FA607D98C80E',
          '05EDCA18-76C4-481C-9910-1F726F0BD94C',
      // options: SendbirdChatOptions(
      //   useCollectionCaching: useCollectionCaching,
      // ),
    );

    var user = await SendbirdChat.connect(
        '2a4b9d95a03ea864a7a2186348941dcbee2b25da',
        apiHost:
            'https://api-05EDCA18-76C4-481C-9910-1F726F0BD94C.sendbird.com/v3/',
        wsHost: 'wss://ws-05EDCA18-76C4-481C-9910-1F726F0BD94C.sendbird.com');

    var session = SendbirdChat.getSessionHandler();
    print(session);

    var pendingPushToken = SendbirdChat.getPendingPushToken();
    // await SendbirdChat.connect(userId);
    var currentUser = SendbirdChat.currentUser;

    print("sendbird>>>$sendbird");
    print("user>>>${user.toJson()}");
    print("pendingPushToken>>>$pendingPushToken");
    print("currentUser>>>${currentUser?.toJson()}");
    var sh = SendbirdChat.getSessionHandler();
    print("session>>>${sh.toString()}");

    //final sessionToken = await SendbirdChat.generateSessionToken();
    // await SendbirdChat.connect(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: start, child: const Text('Sendbird'))
          ],
        ),
      ),
    );
  }
}
