import 'package:flutter/material.dart';

class IconButtonHoverColored extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color iconColor;
  final Color? backColor;

  const IconButtonHoverColored({
    Key? key,
    this.onPressed,
    required this.icon,
    this.iconColor = Colors.white,
    this.backColor = Colors.blueGrey,
  }) : super(key: key);

  @override
  _IconButtonHoverColored createState() => _IconButtonHoverColored();
}

class _IconButtonHoverColored extends State<IconButtonHoverColored> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
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
          color: isHovered ? widget.backColor : Colors.transparent,
          child: Icon(
            widget.icon,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}
