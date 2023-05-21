
  import 'package:flutter/material.dart';

final ButtonStyle buttonPrimaryOrange = ElevatedButton.styleFrom(
  backgroundColor: Colors.orange.shade800, elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(50),
    )
  )
);

  final ButtonStyle buttonPrimaryBlue = ElevatedButton.styleFrom(
      minimumSize: const Size(327, 50), backgroundColor: Colors.blueAccent.shade700, elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          )
      )
  );