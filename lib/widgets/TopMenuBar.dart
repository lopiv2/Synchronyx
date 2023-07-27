import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialStateProperty<Color?> myColor = MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    return Constants.sideBarColor; // Color normal
  },
);

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          child: MenuBar(
            style: MenuStyle(
              backgroundColor: myColor,
            ),
            children: <Widget>[
              SubmenuButton(
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MenuBar Sample',
                        applicationVersion: '1.0.0',
                      );
                    },
                    child: const MenuAcceleratorLabel('&About'),
                  ),
                  SubmenuButton(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child: const MenuAcceleratorLabel('&About'),
                      ),
                    ],
                    child: const MenuAcceleratorLabel('&File'),
                  ),
                ],
                child: const MenuAcceleratorLabel('&File'),
              ),
              SubmenuButton(
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MenuBar Sample',
                        applicationVersion: '1.0.0',
                      );
                    },
                    child: const MenuAcceleratorLabel('&About'),
                  ),
                  SubmenuButton(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child: const MenuAcceleratorLabel('&About'),
                      ),
                    ],
                    child: const MenuAcceleratorLabel('&File'),
                  ),
                ],
                child: const MenuAcceleratorLabel('&File'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
