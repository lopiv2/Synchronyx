import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart';
import 'package:synchronyx/widgets/platform_tree_view.dart';
import 'package:synchronyx/widgets/top_menu_bar.dart';
import 'widgets/arcade_box_button.dart';
import 'widgets/drop_down_filter_order_games.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'widgets/grid_view_game_covers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1024, 768);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Synchronyx";
    win.show();
  });
  //Constants.database = await createAndOpenDB();
  //Constants.database = await openExistingDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Esta línea elimina el banner de depuración
      title: 'Synchronyx Game Launcher',
      localizationsDelegates:
          AppLocalizations.localizationsDelegates, // Cambio aquí
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: MainGrid(context: context),
      ),
    );
  }
}

class MainGrid extends StatelessWidget {
  final BuildContext context;

  const MainGrid({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      color: Constants.SIDE_BAR_COLOR,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyMenuBar(appLocalizations: appLocalizations),
              Expanded(
                flex: 2,
                child: WindowTitleBarBox(
                  child: MoveWindow(),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Center(
                  // Usamos Center para centrar el ArcadeBoxButtonWidget vertical y horizontalmente
                  child: ArcadeBoxButtonWidget(),
                ),
              ),
              const WindowButtons(),
            ],
          ),
          Expanded(
            // Utiliza Expanded aquí para que el Column ocupe todo el espacio vertical disponible
            child: Row(
              children: [
                LeftSide(appLocalizations: appLocalizations),
                const CenterSide(),
                RightSide(appLocalizations: appLocalizations),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeftSide extends StatelessWidget {
  final AppLocalizations appLocalizations;
  const LeftSide({super.key, required this.appLocalizations});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.18,
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
        child: Column(children: [
          //Padding(padding: EdgeInsets.only(top: 10.0)),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
            height: 30,
            child: const Row(
              children: <Widget>[
                SizedBox(width: 10), // give it width
                Flexible(
                    child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    filled: true,
                    fillColor: Color.fromARGB(127, 11, 129, 46),
                    border: OutlineInputBorder(), // Aquí establecemos el borde
                    hintText: 'Search', // Texto de ayuda dentro del TextField
                  ),
                  style: TextStyle(fontSize: 14),
                )),
                SizedBox(width: 10),
              ],
            ),
          ),

          const Padding(padding: EdgeInsets.only(top: 20.0)),
          const DropdownWidget(),
          Expanded(child: PlatformTreeView(appLocalizations: appLocalizations)),
        ]));
  }
}

class CenterSide extends StatelessWidget {
  const CenterSide({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database?>(
      future: createAndOpenDB(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null) {
          return Text('La base de datos no se inicializó correctamente.');
        } else {
          Constants.database = snapshot.data;
          return Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Constants.BACKGROUND_START_COLOR,
                    Constants.BACKGROUND_END_COLOR,
                    Color.fromARGB(255, 48, 87, 3)
                  ],
                ),
              ),
              child: const GridViewGameCovers(),
            ),
          );
        }
      },
    );
  }
}

class RightSide extends StatelessWidget {
  final AppLocalizations appLocalizations;

  const RightSide({Key? key, required this.appLocalizations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
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
      child: Column(
        children: [
          //Padding(padding: EdgeInsets.only(top: 10.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                children: [
                  Icon(Icons.favorite, size: 20, color: Colors.red),
                ],
              ),
              Column(
                children: [
                  Text(appLocalizations.menu),
                  const Text('Synchronyx'),
                ],
              ),
              const Column(
                children: [
                  Icon(Icons.menu, size: 20, color: Colors.blue),
                ],
              ),
            ],
          ),

          const Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
            height: 30,
            child: const Row(
              children: <Widget>[
                SizedBox(width: 10), // give it width
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      filled: true,
                      fillColor: Color.fromARGB(127, 11, 129, 46),
                      border: OutlineInputBorder(),
                      hintText: 'Search',
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          const DropdownWidget(),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      MinimizeWindowButton(),
      MaximizeWindowButton(),
      CloseWindowButton()
    ]);
  }
}
