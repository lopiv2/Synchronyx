import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/utilities/Constants.dart';

class AnimationsDropdownWithTextToLeft extends StatefulWidget {
  const AnimationsDropdownWithTextToLeft(
      {super.key, required this.defaultValue, required this.appLocalizations});
  final AppLocalizations appLocalizations;
  final AnimationsDropDown defaultValue;
  @override
  // ignore: library_private_types_in_public_api
  _AnimationsDropdownWithTextToLeftState createState() =>
      _AnimationsDropdownWithTextToLeftState();
}

class _AnimationsDropdownWithTextToLeftState
    extends State<AnimationsDropdownWithTextToLeft> {
  AnimationsDropDown selectedValue = AnimationsDropDown.FadeInDown; // Valor seleccionado inicialmente
  List<AnimationsDropDown> items = AnimationsDropDown.values;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Expanded(
      child: Row(
        children: [
          const SizedBox(
              width: 20),
          Text(widget.appLocalizations.optionsSelectLogoAnimation),
          const SizedBox(
              width: 20),
          DropdownButton<AnimationsDropDown>(
            value: selectedValue,
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue!;
                appState.updateLogoAnimation(selectedValue.toString().split('.').last);
              });
            },
            items: items.map<DropdownMenuItem<AnimationsDropDown>>(
            (AnimationsDropDown value) {
              return DropdownMenuItem<AnimationsDropDown>(
                value: value,
                child: Text(
                  value.toString().split('.').last,
                ),
              );
            },
          ).toList()
            ..sort((a, b) => a.child.toString().compareTo(b.child.toString())),
          ),
        ],
      ),
    );
  }
}
