import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialStateProperty<Color?> myColor =
    MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    return Constants.sideBarColor; // Color normal
  },
);

class MyMenuBar extends StatelessWidget {
  final AppLocalizations appLocalizations;

  const MyMenuBar({Key? key, required this.appLocalizations}) : super(key: key);

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
                child: MenuAcceleratorLabel(appLocalizations.menu),
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
