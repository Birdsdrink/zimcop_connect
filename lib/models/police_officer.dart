class PoliceOfficer {
  final String? surname;
  final String? forceNo;
  final String? rank;
  final String? uid;
  final String? email;
  final String? profilePicUrl;
  final String? situation;
  final bool? isOnline;
  final DateTime lastSeen;
  final String fcmToken;

  PoliceOfficer({
    required this.surname,
    required this.forceNo,
    required this.rank,
    required this.uid,
    required this.email,
    required this.profilePicUrl,
    required this.situation,
    required this.isOnline,
    required this.lastSeen,
    required this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'surname': surname,
      'forceNo': forceNo,
      'rank': rank,
      'uid': uid,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'situation': situation,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'fcmToken': fcmToken
    };
  }

  factory PoliceOfficer.fromMap(Map<String, dynamic> map) {
    return PoliceOfficer(
        surname: map['surname'],
        forceNo: map['forceNo'],
        rank: map['rank'],
        uid: map['uid'],
        email: map['email'],
        profilePicUrl: map['profilePicUrl'],
        situation: map['situation'],
        isOnline: map['isOnline'],
        lastSeen: map['lastSeen'],
        fcmToken: map['fcmToken']);
  }
}
