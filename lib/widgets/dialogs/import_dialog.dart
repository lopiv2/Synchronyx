import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImportDialog extends StatefulWidget {
  final IconData titleIcon;
  final String title;
  final Color iconColor;
  final AppLocalizations appLocalizations; // Agregar este campo
  final List<Widget> steps; // List of widgets that represent the steps
  final Function(Map<String, dynamic>)? onFinish;

  const ImportDialog({
    Key? key,
    required this.titleIcon,
    required this.title,
    required this.steps,
    required this.appLocalizations,
    this.onFinish,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  _ImportDialogState createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  int _currentStep = 0; // Current step state (initialized at 0)
  Offset _offset = const Offset(0, 0);

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
          child: Stack(
            children: [
              Positioned.fill(
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
                    Expanded(
                      child: _buildStepContent(),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: _currentStep == 0
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep -= 1;
                            });
                          },
                          child: Text(widget.appLocalizations.back),
                        ),
                      if (_currentStep < widget.steps.length - 1)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep += 1;
                                });
                              },
                              child: Text(widget.appLocalizations.next),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .red, // Change the button color to red
                              ),
                              child: Text(widget.appLocalizations.cancel),
                            ),
                          ],
                        ),
                      if (_currentStep == widget.steps.length - 1)
                        ElevatedButton(
                          onPressed: () {
                            //Refresh games
                            Provider.of<AppState>(context, listen: false)
                                .refreshGridView();
                            // Resets Static vars for avoiding garbage in memory
                            Constants.foundApiBeforeImport = null;
                            Constants.controllerMapList = [];
                            Navigator.of(context).pop();
                          },
                          child: Text(widget.appLocalizations.finish),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.steps.isNotEmpty)
            widget
                .steps[_currentStep], // Display the widget of the current step
          const SizedBox(height: 20),
          // Additional content here if needed
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final Widget child;
  final Offset offset;

  const CustomDialog({super.key, required this.child, required this.offset});

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
