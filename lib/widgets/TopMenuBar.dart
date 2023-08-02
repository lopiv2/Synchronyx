import 'package:flutter/material.dart';
import 'package:synchronyx/icons/custom_icons_icons.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/utilities/GenericFunctions.dart';
import 'package:synchronyx/widgets/GeneralDialog.dart';

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
                        child: const MenuAcceleratorLabel('&Open'),
                      ),
                    ],
                    child: MenuAcceleratorLabel('&' + appLocalizations.file),
                  ),
                ],
                child: MenuAcceleratorLabel('&' + appLocalizations.menu),
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
                        leadingIcon: const Icon(CustomIcons.amazon_games,
                            color: Colors.orange, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return MovableDialog(
                                iconColor: Colors.orange,
                                titleIcon: CustomIcons.amazon_games,
                                title: appLocalizations.importSteamWindowTitle,
                                contentText: appLocalizations.importSteamWindowTitle,
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importAmazon),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(
                          CustomIcons.battle_net,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importBattle),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.epicgames),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importEpic),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.gog_dot_com,
                            color: Color.fromARGB(255, 84, 9, 97)),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child: MenuAcceleratorLabel(appLocalizations.importGog),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(
                          CustomIcons.itch_dot_io,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importItch),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.origin,
                            color: Colors.orange),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importOrigin),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.steam,
                            color: Color.fromARGB(255, 12, 66, 94)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return MovableDialog(
                                iconColor: Color.fromARGB(255, 12, 66, 94),
                                titleIcon: CustomIcons.steam,
                                title: appLocalizations.importSteamWindowTitle,
                                contentText: appLocalizations.importSteamWindowTitle,
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importSteam),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.ubisoft,
                            color: Colors.blueAccent),
                        onPressed: () {},
                        child: MenuAcceleratorLabel(appLocalizations.importUbi),
                      ),
                      MenuItemButton(
                        leadingIcon:
                            const Icon(CustomIcons.windows, color: Colors.blue),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child: MenuAcceleratorLabel(
                            appLocalizations.importWindows),
                      ),
                      MenuItemButton(
                        leadingIcon:
                            const Icon(CustomIcons.xbox, color: Colors.green),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importXbox),
                      ),
                    ],
                    child: MenuAcceleratorLabel(appLocalizations.import),
                  ),
                ],
                child: MenuAcceleratorLabel('&' + appLocalizations.tools),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
