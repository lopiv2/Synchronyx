import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';

class TextButtonHoverColored extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final ButtonStyle? style;
  final Color? backColor;

  const TextButtonHoverColored({
    Key? key,
    this.onPressed,
    this.style,
    required this.text,
    this.backColor = Colors.blueGrey,
  }) : super(key: key);

  @override
  _TextButtonHoverColored createState() => _TextButtonHoverColored();
}

class _TextButtonHoverColored extends State<TextButtonHoverColored> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isHovered ? widget.backColor : Colors.transparent,
            border: appState.buttonClickedKey == widget.key
                ? Border.all(
                    color: Colors.blue,
                    width: 2.0) // Borde cuando está presionado
                : null,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                    40),bottomRight: Radius.circular(40)), // Ajusta el valor según tu preferencia
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}
