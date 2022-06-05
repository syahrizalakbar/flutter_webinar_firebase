import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webinar_firebase/model/makanan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription<Event> streamSubscription;
  StreamSubscription<Event> streamSubscriptionDeleted;
  List<Makanan> makanan = [];

  StreamSubscription<Event> streamSubscriptionChanged;

  @override
  void initState() {
    streamSubscription =
        db.reference().child("makanan").onChildAdded.listen((event) {
          setState(() {
            var m = Makanan.fromSnapshot(event.snapshot);
            makanan.add(m);
          });
    });
    streamSubscriptionDeleted =
        db.reference().child("makanan").onChildRemoved.listen((event) {
          var index = makanan.indexWhere((element) {
            if (element.key == event.snapshot.key) {
              return true;
            } else {
              return false;
            }
          });
          if (index != null) {
            setState(() {
              makanan.removeAt(index);
            });
          }
    });
    streamSubscriptionChanged =
        db.reference().child("makanan").onChildChanged.listen((event) {
          var m = Makanan.fromSnapshot(event.snapshot);
          var index = makanan.indexWhere((element) {
            if (element.key == event.snapshot.key) {
              return true;
            } else {
              return false;
            }
          });
          if (index != null) {
            setState(() {
              makanan[index] = m;
            });
          }
    });

    /*

        POST /fcm/send HTTP/1.1
        Host: fcm.googleapis.com
        Authorization: key=AAAAtag31JM:APA91bFNQBhRLQURw7G4z4X8dgu3jbdXUDYSnekUgCOEnnc4N6dbYT8YvnOaKUJAax4t4978aNClD-7IlSj_qH3drMih6kx28VmZokhxREUheZIuYCa6f6NygJIeUQrh0DcZX_u0sIwO
        Content-Type: application/json
        Content-Length: 418

        {
            "to": "/topics/news",
            "registration_ids": [
                "dj8U_o-gSSy1qOT1zKMa5C:APA91bF9cQBi3qB4enLflsHB8K5yhLuWtfPS8DmecQUoCjNLxeHAwLBzsC_b0FGftwrD3Rp_3LyyfB4pxQsOkTcM1NO6Yh1KrNPxzaOfia-5BhRNQjnVTaGGwggWeqDmQnXO0MhB8WxJ",
                "asdasdsad"
            ],
            "notification": {
                "title": "Breaking News",
                "body": "New news story available."
            },
            "data": {
                "story_id": "story_12345"
            }
        }

     */

    _firebaseMessaging.subscribeToTopic("news");
    _firebaseMessaging.getToken().then((value) {
        print(value);
      });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    streamSubscriptionDeleted?.cancel();
    streamSubscriptionChanged?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firebase FCM"),
      ),
      body: ListView.builder(
        itemCount: makanan.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(makanan[index].nama),
              subtitle: Text(makanan[index].harga.toString()),
              leading: Text(makanan[index].rating.toString()),
            ),
          );
        },
      ),
    );
  }
}
