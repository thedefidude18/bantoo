import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String date;
  final String emoji;
  final bool isRead;
  final String message;
  final String senderUid;
  final String time;
  final DateTime timestamp;
  final String? imageUrl; // Optional field

  MessageModel({
    required this.date,
    required this.emoji,
    required this.isRead,
    required this.message,
    required this.senderUid,
    required this.time,
    required this.timestamp,
    this.imageUrl, // imageUrl is optional
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      date: data['date'] ?? '',
      emoji: data['emoji'] ?? '',
      isRead: data['isRead'] ?? true,
      message: data['message'] ?? '',
      senderUid: data['senderUid'] ?? '',
      time: data['time'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'], // Optional field
    );
  }

  // ToMap method if you need to save it back to Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'emoji': emoji,
      'isRead': isRead,
      'message': message,
      'senderUid': senderUid,
      'time': time,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl, // Optional field, might be null
    };
  }
}
