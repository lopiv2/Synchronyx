import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: MenuBar(
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
