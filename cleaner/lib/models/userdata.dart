import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{
  final String name;
  final String email;
  final String phone;
  final String password;

  final String uid;

  const UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Email": email,
    "Phone": phone,
    "Password": password,
    "UserID": uid,
  };

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      name: snapshot['Name'],
      email: snapshot['Email'],
      phone: snapshot['Phone'],
      password: snapshot['Password'],
      uid: snapshot['UserID'],
    );
  }
}

