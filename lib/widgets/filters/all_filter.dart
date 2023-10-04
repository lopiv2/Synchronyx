import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/widgets/buttons/text_button_colored.dart';

class AllFilterColumn extends StatelessWidget {
  const AllFilterColumn({required this.appLocalizations, super.key});

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Container(
          padding: const EdgeInsets.all(10.0), // Padding del contenedor
          child: ListView(children: <Widget>[
            TextButtonHoverColored(
              text: appLocalizations.all,
              key: const ValueKey(1),
              onPressed: (() => {
                    appState.updateFilters('all', 'all'),
                    appState.updateButtonClickedKey(ValueKey(1)),
                    appState.updateSelectedGame(null),
                    appState.refreshGridView()
                  }),
            ),
          ]));
    });
  }
}
