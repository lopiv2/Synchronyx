import 'package:flutter/material.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsDialog extends StatefulWidget {
  final IconData titleIcon;
  final String title;
  final Color iconColor;
  final AppLocalizations appLocalizations; // Agregar este campo
  final Function(Map<String, dynamic>)? onFinish;

  const SettingsDialog({
    Key? key,
    required this.titleIcon,
    required this.title,
    required this.appLocalizations,
    this.onFinish,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  Offset _offset = Offset(0, 0);
  final List<String> options = ['Option 1', 'Option 2', 'Option 3'];
  Widget _propertiesWidget = Container();

  void _onOptionSelected(int index) {
    setState(() {
      //_currentStep = index + 1;
      // Aquí configura las propiedades para la opción seleccionada
      _propertiesWidget = Container(
        width: 80,
        height: 80,
        child: Text('Properties for ${options[index]}'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
      },
      child: CustomDialog(
        offset: _offset,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 2, 34, 14),
              width: 0.2,
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Constants.SIDE_BAR_COLOR,
                Color.fromARGB(255, 33, 109, 72),
                Color.fromARGB(255, 48, 87, 3),
              ],
            ),
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Constants.SIDE_BAR_COLOR,
                elevation: 0.0,
                toolbarHeight: 35.0,
                titleSpacing: -20.0,
                leading: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    widget.titleIcon,
                    color: widget.iconColor,
                  ),
                ),
                title: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  LeftColumn(
                    options: options,
                    onOptionSelected: _onOptionSelected,
                  ),
                  SizedBox(width: 16),
                  RightColumn(
                    propertiesWidget: _propertiesWidget,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeftColumn extends StatelessWidget {
  final List<String> options;
  final Function(int) onOptionSelected;

  LeftColumn({required this.options, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 2, 34, 14), // Color del borde
          width: 0.2, // Ancho del borde
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Constants.SIDE_BAR_COLOR,
            Color.fromARGB(255, 33, 109, 72),
            Color.fromARGB(255, 48, 87, 3)
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.18,
      child: Column(
        children: options
            .asMap()
            .map((index, option) => MapEntry(
                  index,
                  ElevatedButton(
                    onPressed: () => onOptionSelected(index),
                    child: Container(
                      width: 150, // Tamaño fijo para el botón
                      child: Center(child: Text(option)),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}

class RightColumn extends StatelessWidget {
  final Widget propertiesWidget;

  RightColumn({required this.propertiesWidget});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.all(16),
        child: propertiesWidget,
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final Widget child;
  final Offset offset;

  const CustomDialog({required this.child, required this.offset});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
