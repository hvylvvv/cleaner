

class ReportData {
  String reportType;
  String additionalInfo;
  bool receiveUpdates;
  String uid;
  String name;


  ReportData({
    required this.reportType,
    required this.additionalInfo,
    required this.receiveUpdates,
    required this.uid,
    required this.name,
  });

  // Convert a RequestData object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'pickupType': reportType,
      'additionalInfo': additionalInfo,
      'receiveUpdates': receiveUpdates,
      'userId': uid,
      'userName': name,
    };
  }

  // Create a RequestData object from a Map (for JSON decoding)
  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      reportType: json['reportType'],
      additionalInfo: json['additionalInfo'],
      receiveUpdates: json['receiveUpdates'],
      uid: json['userId'],
      name: json['name'],
    );
  }
}
