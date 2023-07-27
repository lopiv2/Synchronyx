import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'package:synchronyx/widgets/ArcadeBoxButton.dart';

class PlutoMenuBarDemo extends StatelessWidget {
  const PlutoMenuBarDemo({
    super.key,
  });

  void message(context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(text),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<PlutoMenuItem> getMenus(BuildContext context) {
    return [
      PlutoMenuItem(title: 'Menu 1', children: [
        PlutoMenuItem(
          title: 'Menu 1-1',
          icon: Icons.group,
          onTap: () => message(context, 'Menu 1-1 tap'),
          children: [
            PlutoMenuItem(
              title: 'Menu 1-1-1',
              onTap: () => message(context, 'Menu 1-1-1 tap'),
              children: [
                PlutoMenuItem(
                  title: 'Menu 1-1-1-1',
                  onTap: () => message(context, 'Menu 1-1-1-1 tap'),
                ),
                PlutoMenuItem(
                  title: 'Menu 1-1-1-2',
                  onTap: () => message(context, 'Menu 1-1-1-2 tap'),
                ),
              ],
            ),
            PlutoMenuItem(
              title: 'Menu 1-1-2',
              onTap: () => message(context, 'Menu 1-1-2 tap'),
            ),
          ],
        ),
      ]),
      PlutoMenuItem(title: 'Menu 2', children: [
        PlutoMenuItem(
          title: 'Menu 1-1',
          icon: Icons.group,
          onTap: () => message(context, 'Menu 1-1 tap'),
          children: [
            PlutoMenuItem(
              title: 'Menu 1-1-1',
              onTap: () => message(context, 'Menu 1-1-1 tap'),
              children: [
                PlutoMenuItem(
                  title: 'Menu 1-1-1-1',
                  onTap: () => message(context, 'Menu 1-1-1-1 tap'),
                ),
                PlutoMenuItem(
                  title: 'Menu 1-1-1-2',
                  onTap: () => message(context, 'Menu 1-1-1-2 tap'),
                ),
              ],
            ),
            PlutoMenuItem(
              title: 'Menu 1-1-2',
              onTap: () => message(context, 'Menu 1-1-2 tap'),
            ),
          ],
        ),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200, // Establece el ancho deseado para el primer PlutoMenuBar
          child: PlutoMenuBar(
            backgroundColor: Constants.sideBarColor,
            menus: getMenus(context),
          ),
        ),
      ],
    );
  }
}
