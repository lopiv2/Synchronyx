import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FileSelectorButton extends StatefulWidget {
  final String? databaseValue; //Value from database
  final AppLocalizations appLocalizations;
  const FileSelectorButton(
      {super.key, required this.databaseValue, required this.appLocalizations});

  @override
  _FileSelectorState createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelectorButton> {
  String? selectedFilePath;
  final TextEditingController textController = TextEditingController();

  void _openFilePicker(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      final filePath = file.path;

      setState(() {
        selectedFilePath = filePath;
        appState.optionsResponse.imageBackgroundFile = filePath;
      });

      textController.text =
          filePath ?? ''; // Configura el valor del controlador
    } else {
      setState(() {
        selectedFilePath = null;
        appState.optionsResponse.imageBackgroundFile = null;
      });

      textController.clear(); // Limpia el valor del controlador
    }
  }

  @override
  void initState() {
    super.initState();
    textController.text = widget.databaseValue ?? '';
    selectedFilePath = widget.databaseValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              height: 40,
              child: TextFormField(
                controller: textController,
                readOnly: false,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(fontSize: 1),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                left: 20), 
            height: 30, 
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _openFilePicker(context);
                },
                child: Text(
                    widget.appLocalizations.optionsSelectBackImageCalendar),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
