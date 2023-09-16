import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/Constants.dart';

class DownloadProgress extends StatefulWidget {
  const DownloadProgress({Key? key});

  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress> {
  StreamController<double> _progressController = StreamController<double>();
  double _progressValue = 0.0;

  @override
  void dispose() {
    _progressController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      if (appState.isDownloading) {
        _downloadFile(context, appState.urlDownloading); // Llama a la función aquí
        return StreamBuilder<double>(
          stream: _progressController.stream,
          initialData: 0.0,
          builder: (context, snapshot) {
            _progressValue = snapshot.data ?? 0.0;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    child: Container(
                      color: Colors.amber,
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: _progressValue / 100,
                            minHeight: 20.0,
                            backgroundColor: Colors.grey,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          Text('${(_progressValue).round()}%'),
                          Text(
                            'Descargando archivo...',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Text("");
      }
    });
  }

  Future<void> _downloadFile(BuildContext context, String url) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final dio = Dio();
    String folder = '\\Synchronyx\\downloads\\';
    List<String> parts = url.split("/");
    String fileName = parts.last;
    await Constants.initialize();
    Directory fileFolder =
        Directory('${Constants.appDocumentsDirectory.path}$folder');
    try {
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: (received, total) {
          if (appState.isDownloading) {
            double progress = (received / total * 100).toDouble();
            _progressController.add(progress); // Actualiza el progreso
          }
        },
      );
      if (response.statusCode == 200) {
        if (!fileFolder.existsSync()) {
          fileFolder.createSync(recursive: true);
        }

        final file = File('${fileFolder.path}$fileName');
        final bodyBytes = response.data;
        await file.writeAsBytes(bodyBytes);

        print('Archivo guardado en: $file');
        _progressController = StreamController<double>();
        await appState.stopDownload();
      } else {
        print('Error al descargar el archivo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
