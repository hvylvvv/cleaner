import 'package:cleaner/models/addressdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleaner/models/userdata.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    String resp = "Some Error occurred";
    try {
      if (name.isNotEmpty ||
          email.isNotEmpty ||
          phone.isNotEmpty ||
          password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        UserData userData = UserData(
          name: name,
          email: email,
          phone: phone,
          password: password,
          uid: cred.user!.uid,
          
        );

        await _fireStore.collection('users').doc(cred.user!.uid).set(
              userData.toJson(),
            );
        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please Enter All The Fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }


  Future<UserData> getUserDetails() async{
    User currentUser  = _auth.currentUser!;
    DocumentSnapshot snap = await _fireStore.collection('users').doc(currentUser.uid).get();
    return UserData.fromSnap(snap);
  }

  Future<String> updateUserAddress({

    required String addressLine1,
    required String addressSuburb,
    required String addressParish,
    required String addressCountry,
    required String addressLatLong,
  }) async {
    String resp = "Some Error occurred";
    try{
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return "No user is currently signed in.";
      }

      if (addressLine1.isNotEmpty ||
          addressSuburb.isNotEmpty ||
          addressParish.isNotEmpty ||
          addressCountry.isNotEmpty ||
          addressLatLong.isNotEmpty
      ) {

        AddressData address = AddressData(

            addressLine1: addressLine1,
            addressSuburb: addressSuburb,
            addressParish: addressParish,
            addressCountry: addressCountry,
            addressLatLong: addressLatLong,
        );

        await _fireStore.collection('users').doc(currentUser.uid).update(address.toJson());

        resp = 'success';
      }

    } catch (err) {
      resp = err.toString();
    }

    return resp;

  }

}