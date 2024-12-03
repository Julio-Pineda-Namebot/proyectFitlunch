// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class ServicioNotificaciones {
//   static final FlutterLocalNotificationsPlugin notificationsPlugin = 
//   FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings
//     ('ic_notification'); 

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//     );


//     await notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveBackgroundNotificationResponse: ,
//       onDidReceiveNotificationResponse: ,
//     );
//   }

//   static Future<void> mostrarNotificacion(String titulo, String cuerpo) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'canal_notificaciones_fitlunch', // Reemplázalo con tu ID de canal
//       'Notificaciones de FitLunch', // Reemplázalo con tu nombre de canal
//       channelDescription: 'Notificaciones sobre nuevos planes, pagos y recordatorios de FitLunch', // Reemplázalo con tu descripción de canal
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _notificationsPlugin.show(
//       0, // ID de la notificación
//       titulo,
//       cuerpo,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }
// }
