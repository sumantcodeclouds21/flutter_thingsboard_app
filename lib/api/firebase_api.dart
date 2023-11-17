import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/services//local_notification_service.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thingsboard_app/utils/services/global.dart' as globals;

Future<String> getCheckNotificationPermStatus() {
  return NotificationPermissions.getNotificationPermissionStatus()
      .then((status) {
    print(status);
    switch (status) {
      case PermissionStatus.denied:
        return 'permDenied';
      case PermissionStatus.granted:
        return 'permGranted';
      case PermissionStatus.unknown:
        return 'permUnknown';
      case PermissionStatus.provisional:
        return 'permProvisional';
      default:
        return '';
    }
  });
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
  // ignore: unnecessary_null_comparison
  if (message == null) return;
  var datas = message.data.toString();
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    getCheckNotificationPermStatus();
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${_firebaseMessaging}');
    print('object---------------');
    final fcmToken = await _firebaseMessaging.getToken();

    print('Token $fcmToken');
    if (fcmToken != '') {
      //initNotification();
      globals.pushToken = fcmToken!;
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    }

    FirebaseMessaging.onMessage.listen(
      (message) {
        print('gfghb');
        print("FirebaseMessaging.onMessage.listen back ground");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data}");
          // navigatorKey.currentState?.pushNamed('/swiper');
          print('object00000000-------------9');
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
  }
}
