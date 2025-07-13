class AppNotification {
  final String title;
  final String body;
  final DateTime receivedTime;
  bool isRead;

  AppNotification({
    required this.title,
    required this.body,
    required this.receivedTime,
    this.isRead = false,
  });
}
