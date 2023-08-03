import 'package:flutter/material.dart';
import 'package:synchronyx/icons/custom_icons_icons.dart';
import 'package:synchronyx/utilities/constants.dart';

class MovableDialog extends StatefulWidget {
  final IconData titleIcon;
  final String title;
  final String contentText;
  final Color iconColor;

  const MovableDialog({
    Key? key,
    required this.titleIcon,
    required this.title,
    required this.contentText,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  _MovableDialogState createState() => _MovableDialogState();
}

class _MovableDialogState extends State<MovableDialog> {
  Offset _offset = Offset(0, 0);

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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Constants.sideBarColor,
                const Color.fromARGB(255, 33, 109, 72),
                const Color.fromARGB(255, 48, 87, 3),
              ],
            ),
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Constants.sideBarColor,
                elevation: 0.0,
                toolbarHeight: 35.0,
                titleSpacing: -20.0,
                leading: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    widget.titleIcon,
                    color: widget
                        .iconColor, // Usamos el color del icono que pasamos como argumento
                  ),
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(
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
                    icon: Icon(Icons.close),
                    color: Colors.white,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.contentText),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                        ],
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
}

class CustomDialog extends StatelessWidget {
  final Widget child;
  final Offset offset;

  CustomDialog({required this.child, required this.offset});

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
