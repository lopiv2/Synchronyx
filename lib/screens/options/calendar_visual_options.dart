import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/widgets/buttons/file_selector_button.dart';

class CalendarVisualOptions extends StatefulWidget {
  final AppLocalizations appLocalizations;
  const CalendarVisualOptions({super.key, required this.appLocalizations});

  @override
  State<CalendarVisualOptions> createState() => _CalendarVisualOptionsState();
}

class _CalendarVisualOptionsState extends State<CalendarVisualOptions> {
  bool imageSelectionButton = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.appLocalizations.optionsGameTitle,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
      Container(
        height: 200,
        color: const Color.fromARGB(3, 244, 67, 54),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Selector<AppState, int>(
              selector: (_, provider) =>
                  provider.optionsResponse.showBackgroundImageCalendar,
              builder: (context, showBackgroundImageCalendar, child) {
                return ToggleSwitch(
                    databaseValue: showBackgroundImageCalendar,
                    text: widget.appLocalizations.options3dBackgroundImage,
                    initialValue: widget.appLocalizations.no,
                    toggleValue: widget.appLocalizations.yes,
                    onChanged: (value) {
                      if (value == true) {
                        showBackgroundImageCalendar = 1;
                      } else {
                        showBackgroundImageCalendar = 0;
                      }
                      appState.optionsResponse.showBackgroundImageCalendar =
                          showBackgroundImageCalendar;
                      setState(() {
                        imageSelectionButton = value;
                      });
                    });
              },
            ),
            Visibility(
                visible:
                    appState.optionsResponse.showBackgroundImageCalendar == 1
                        ? true
                        : false,
                child: FileSelectorButton())
          ],
        ),
      ),
    ]);
  }

  _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType
          .any, // Puedes especificar el tipo de archivo que deseas seleccionar (ejemplo: FileType.image)
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print("Ruta del archivo: ${file.path}");
      print("Nombre del archivo: ${file.name}");
      print("Tamaño del archivo: ${file.size}");
    } else {
      // El usuario canceló la selección de archivos
    }
  }
}

class ToggleSwitch extends StatefulWidget {
  final int databaseValue; //Value from database
  final String text;
  final String initialValue;
  final String toggleValue;
  final ValueChanged<bool> onChanged;
  const ToggleSwitch({
    super.key,
    required this.text,
    required this.initialValue,
    required this.onChanged,
    required this.databaseValue,
    required this.toggleValue,
  });

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<ToggleSwitch> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.databaseValue == 1 ? true : false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              widget.onChanged(value);
            });
          },
        ),
        const SizedBox(height: 20),
        Text(
          '${widget.text}: - ${isSwitched ? widget.toggleValue : widget.initialValue}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
