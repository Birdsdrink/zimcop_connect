import 'package:cloud_firestore/cloud_firestore.dart';

class CallingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  //Accepted Calls
  Future<void> acceptedCalls(id, Map<String, dynamic> callerInfo) async {
    return await _firestore
        .collection("All Calls")
        .doc()
        .collection("Accepted Calls")
        .doc(id)
        .set(callerInfo);
  }
}
