import 'package:flutter/material.dart';
import 'package:zimcop_connect/models/police_officer.dart';

class CustomCircularImage extends StatelessWidget {
  final double size;
  final PoliceOfficer officer;

  const CustomCircularImage(
      {super.key, required this.size, required this.officer});

  bool get isImageProvided => officer.profilePicUrl != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isImageProvided ? null : Colors.green,
          image: !isImageProvided
              ? null
              : DecorationImage(image: NetworkImage(officer.profilePicUrl!))),
      child: isImageProvided
          ? const SizedBox()
          : Center(
        child: Text(officer.surname![0].toUpperCase()),
      ),
    );
  }
}
