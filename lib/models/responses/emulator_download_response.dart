import 'package:flutter/material.dart';

class EmulatorDownloadResponse {
  final String system; //Android, Windows, Mac or Linux
  final String? url;
  final IconData? image;

  EmulatorDownloadResponse({
    required this.system,
    this.url, 
    this.image,  
  });
}
