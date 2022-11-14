class NotificationModel {
  final String? timestamp;
  final DateTime? date;
  final String? title;
  final String? body;
  final int? postID;
  final String? thumbnailUrl;
  String ?sender;

  NotificationModel({
    this.timestamp,
    this.date,
    this.title,
    this.body,
    this.postID,
    this.thumbnailUrl,
    this.sender
  });
}
