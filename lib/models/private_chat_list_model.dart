class PrivateChatListModel {
  final String userId;
  final String? senderName; // Added this field
  final String body;
  final String? userImage;
  final String? currentUserImage;
  final String type;
  final dynamic creationDate;
  final String title;
  final String amount;
  final String selectedOption;
  final String eventId;

  PrivateChatListModel({
    required this.userId,
    this.senderName, // Initialize this field
    required this.body,
    this.userImage,
    this.currentUserImage,
    required this.type,
    required this.creationDate,
    required this.title,
    required this.amount,
    required this.selectedOption,
    required this.eventId,
  });

  factory PrivateChatListModel.fromJson(Map<String, dynamic> json) {
    return PrivateChatListModel(
      userId: json['id'],
      senderName: json['senderName'] ?? '', // Parse this field
      body: json['body'],
      userImage: json['userImage'],
      currentUserImage: json['currentUserImage'],
      type: json['type'],
      creationDate: json['creationDate'],
      title: json['title'],
      amount: json['eventAmount'] ?? '',
      selectedOption: json['selectedOption'] ?? '',
      eventId: json['eventId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'senderName': senderName, // Serialize this field
      'body': body,
      'userImage': userImage,
      'currentUserImage': currentUserImage,
      'type': type,
      'creationDate': creationDate,
      'title': title,
      'eventAmount': amount,
      'selectedOption': selectedOption,
      'eventId': eventId,
    };
  }

  // Override the toString method
  @override
  String toString() {
    return 'PrivateChatListModel('
        'userId: $userId, '
        'senderName: $senderName, '
        'body: $body, '
        'userImage: $userImage, '
        'currentUserImage: $currentUserImage, '
        'type: $type, '
        'creationDate: $creationDate, '
        'title: $title, '
        'amount: $amount, '
        'selectedOption: $selectedOption, '
        'eventId: $eventId)';
  }
}
