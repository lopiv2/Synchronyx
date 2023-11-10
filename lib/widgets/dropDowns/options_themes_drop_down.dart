import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/models/themes.dart' as Theme;
import 'package:lioncade/models/themes.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/utilities/Constants.dart';
import 'package:lioncade/utilities/generic_database_functions.dart';

class ThemesDropdownWithTextToLeft extends StatefulWidget {
  const ThemesDropdownWithTextToLeft({
    super.key,
    required this.defaultValue,
    required this.appLocalizations,
  });

  final AppLocalizations appLocalizations;
  final String defaultValue;

  @override
  _ThemesDropdownWithTextToLeftState createState() =>
      _ThemesDropdownWithTextToLeftState();
}

class _ThemesDropdownWithTextToLeftState
    extends State<ThemesDropdownWithTextToLeft> {
  String selectedValue = ''; // Valor seleccionado inicialmente
  late Future<List<Themes>> items;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultValue;
    items = getAllThemes();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Expanded(
      child: Row(
        children: [
          //const SizedBox(width: 20),
          FutureBuilder<List<Themes>>(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('Loading themes...');
              } else {
                final themes = snapshot.data!;
                return DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (newValue) async {
                    setState(() {
                      selectedValue = newValue!;
                    });
                    Themes? theme = await getThemeByName(newValue ?? '');                 
                      appState.optionsResponse.selectedTheme = theme!.name;                 
                  },
                  items: themes.map<DropdownMenuItem<String>>(
                    (theme) {
                      return DropdownMenuItem<String>(
                        value: theme.name,
                        child: Text(
                          theme.name,
                        ),
                      );
                    },
                  ).toList()
                    ..sort((a, b) => a.value!.compareTo(b.value!)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
