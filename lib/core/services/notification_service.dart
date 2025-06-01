import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showBudgetExceededNotification({
    required String title,
    required String subTitle,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'budget_alert_channel',
      'Cảnh báo ngân sách',
      channelDescription: 'Thông báo khi chi tiêu vượt ngân sách',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      1,
      '⚠️ $title!!!',
      '$subTitle!',
      details,
    );
  }

  Future<void> scheduleDailyReminder() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Nhắc nhập chi tiêu',
      channelDescription: 'Thông báo nhắc nhập chi tiêu hằng ngày',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        1001,
        '💰 Nhập chi tiêu buổi trưa',
        'Bạn đã chi gì trưa nay chưa?',
        _nextInstanceOfTime(6, 0),
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        1002,
        '📋 Nhập chi tiêu buổi tối',
        'Đừng quên ghi lại chi tiêu hôm nay!',
        _nextInstanceOfTime(13, 0),
        details,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
