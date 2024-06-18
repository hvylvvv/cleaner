

class RequestData {
  String pickupType;
  String date;
  String time;
  String additionalInfo;
  bool receiveUpdates;
  String uid;
  String name;
  // String pickupId;



  RequestData({
    required this.pickupType,
    required this.date,
    required this.time,
    required this.additionalInfo,
    required this.receiveUpdates,
    required this.uid,
    required this.name,
    // required this.pickupId

  });

  // Convert a RequestData object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {

    return {
      'pickupType': pickupType,
      'date': date,
      'time': time,
      'additionalInfo': additionalInfo,
      'receiveUpdates': receiveUpdates,
      'userId': uid,
      'userName': name,
      // 'pickupId': documentReference.id,

    };
  }

  // Create a RequestData object from a Map (for JSON decoding)
  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
      pickupType: json['pickupType'],
      date: json['date'],
      time: json['time'],
      additionalInfo: json['additionalInfo'],
      receiveUpdates: json['receiveUpdates'],
      uid: json['userId'],
      name: json['name'],
      // pickupId: json['pickupId']

    );
  }
}
