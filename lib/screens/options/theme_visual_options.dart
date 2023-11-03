import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/models/themes.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'package:synchronyx/widgets/buttons/file_selector_button.dart';
import 'package:synchronyx/widgets/dropDowns/options_animations_drop_down.dart';
import 'package:synchronyx/widgets/dropDowns/options_themes_drop_down.dart';

class ThemeVisualOptions extends StatefulWidget {
  final AppLocalizations appLocalizations;
  const ThemeVisualOptions({super.key, required this.appLocalizations});

  @override
  State<ThemeVisualOptions> createState() => _ThemeVisualOptionsState();
}

class _ThemeVisualOptionsState extends State<ThemeVisualOptions> {
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
            Text(widget.appLocalizations.optionsThemeTitle,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
      Container(
        height: 100,
        color: const Color.fromARGB(3, 244, 67, 54),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Selector<AppState, String>(
              selector: (_, provider) =>
                  provider.optionsResponse.selectedTheme,
              builder: (context, selectedTheme, child) {
                return Row(
                  children: [
                    Text(widget.appLocalizations.optionsSelectedTheme),
                    const SizedBox(width: 20,),
                    ThemesDropdownWithTextToLeft(defaultValue: selectedTheme, appLocalizations: widget.appLocalizations),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ]);
  }
}