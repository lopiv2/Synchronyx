import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileSelectorButton extends StatefulWidget {
  @override
  _FileSelectorState createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelectorButton> {
  String? selectedFilePath;

  _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFilePath = file.path;
      });
    } else {
      setState(() {
        selectedFilePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white, // Fondo blanco
              child: TextFormField(
                initialValue: selectedFilePath,
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _openFilePicker();
            },
            child: Text("Seleccionar Archivo"),
          ),
        ],
      ),
    );
  }
}
