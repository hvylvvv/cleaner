import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  bool resolved;
  String info;
  GeoPoint location;
  String title;

  CommunityPost({
    required this.resolved,
    required this.info,
    required this.location,
    required this.title,
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CommunityPost(
      resolved: data['Resolved'] ?? false,
      info: data['info'] ?? '',
      location: data['location'] ?? const GeoPoint(0.0, 0.0),
      title: data['title'] ?? '',
    );
  }
}
