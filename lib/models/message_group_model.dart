class MessageChannleModel {
  String senderId;
  String dateTime;
  String text;

  MessageChannleModel({
    this.senderId,
    this.dateTime,
    this.text,
  });

  MessageChannleModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'dateTime': dateTime,
      'text': text,
    };
  }
}
