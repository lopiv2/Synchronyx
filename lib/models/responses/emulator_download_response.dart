class EmulatorDownloadResponse {
  final String system; //Android, Windows, Mac or Linux
  final String? url;

  EmulatorDownloadResponse({
    required this.system,
    this.url,   
  });
}
