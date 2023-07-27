import 'package:flutter/material.dart';
import 'package:synchronyx/widgets/MainTopMenuBar.dart';
import 'package:synchronyx/widgets/TopMenuBar.dart';
import 'widgets/ArcadeBoxButton.dart';
import 'widgets/DropDownFilterOrderGames.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'widgets/GridViewGameCovers.dart';

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(800, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Synchronyx";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Esta línea elimina el banner de depuración
      title: 'Flutter Demo',
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
        body: MainGrid(),
      ),
    );
  }
}

class MainGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Constants.sideBarColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10), // give it width
                const PlutoMenuBarDemo(),
                Expanded(
                  flex: 2,
                  child: WindowTitleBarBox(
                    child: MoveWindow(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    // Usamos Center para centrar el ArcadeBoxButtonWidget vertical y horizontalmente
                    child: ArcadeBoxButtonWidget(),
                  ),
                ),
                Expanded(child: WindowButtons(), flex: 0),
              ],
            ),
            const Expanded(
              // Utiliza Expanded aquí para que el Column ocupe todo el espacio vertical disponible
              child: Row(
                children: [
                  LeftSide(),
                  CenterSide(),
                  RightSide(),
                ],
              ),
            ),
          ],
        ));
  }
}

class LeftSide extends StatelessWidget {
  const LeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 2, 34, 14), // Color del borde
          width: 0.2, // Ancho del borde
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Constants.sideBarColor,
            const Color.fromARGB(255, 33, 109, 72),
            const Color.fromARGB(255, 48, 87, 3)
          ],
        ),
      ),
      child: Column(
        children: [
          //Padding(padding: EdgeInsets.only(top: 10.0)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.favorite, size: 20, color: Colors.red),
                ],
              ),
              Column(
                children: [
                  Text('Synchronyx'),
                ],
              ),
              Column(
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
                    border: OutlineInputBorder(), // Aquí establecemos el borde
                    hintText: 'Search', // Texto de ayuda dentro del TextField
                    // Otros estilos de la decoración (opcional)
                    // labelStyle: TextStyle(color: Colors.red),
                    // hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(fontSize: 14),
                )),
                SizedBox(width: 10), // give it width
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

class CenterSide extends StatelessWidget {
  const CenterSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Constants.backgroundStartColor,
                Constants.backgroundEndColor,
                const Color.fromARGB(255, 48, 87, 3)
              ],
            ),
          ),
          child: GridViewGameCovers()),
    );
  }
}

class RightSide extends StatelessWidget {
  const RightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 2, 34, 14), // Color del borde
          width: 0.2, // Ancho del borde
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Constants.sideBarColor,
            const Color.fromARGB(255, 33, 109, 72),
            const Color.fromARGB(255, 48, 87, 3)
          ],
        ),
      ),
      child: Column(
        children: [
          const MyMenuBar(),
          //Padding(padding: EdgeInsets.only(top: 10.0)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.favorite, size: 20, color: Colors.red),
                ],
              ),
              Column(
                children: [
                  Text('Synchronyx'),
                ],
              ),
              Column(
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
                    border: OutlineInputBorder(), // Aquí establecemos el borde
                    hintText: 'Search', // Texto de ayuda dentro del TextField
                    // Otros estilos de la decoración (opcional)
                    // labelStyle: TextStyle(color: Colors.red),
                    // hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(fontSize: 14),
                )),
                SizedBox(width: 10), // give it width
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
