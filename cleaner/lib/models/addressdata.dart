import 'package:cloud_firestore/cloud_firestore.dart';

class AddressData{
  final String addressLine1;
  final String addressNeighbourhood;
  final String addressSuburb;
  final String addressParish;
  final String addressCountry;
  final String addressLatLong;

  const AddressData({
    required this.addressLine1,
    required this.addressNeighbourhood,
    required this.addressSuburb,
    required this.addressParish,
    required this.addressCountry,
    required this.addressLatLong,
  });

  Map<String, dynamic> toJson() => {
    "AddressLine1": addressLine1,
    "AddressNeighbourhood": addressNeighbourhood,
    "AddressSuburb": addressSuburb,
    "AddressParish": addressParish,
    "AddressCountry": addressCountry,
    "AddressLatLong": addressLatLong,

  };

  static AddressData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddressData(
      addressLine1: snapshot['AddressLine1'],
       addressNeighbourhood: snapshot['AddressNeighbourhood'],
      addressSuburb: snapshot['AddressSuburb'],
      addressParish: snapshot['Parish'],
      addressCountry: snapshot['Country'],
      addressLatLong: snapshot['GeoLocation']
    );
  }
}
