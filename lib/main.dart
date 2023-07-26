import 'package:flutter/material.dart';
import 'widgets/ArcadeBoxButton.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

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

var sideBarColor = Color.fromARGB(255, 71, 192, 60);
var backgroundStartColor = Color.fromARGB(255, 33, 187, 115);
var backgroundEndColor = Color.fromARGB(255, 5, 148, 29);

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

/*class MainGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LeftSide(),
        RightSide(),
      ],
    );
  }
}*/

class MainGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MoveWindow(),
                /*WindowTitleBarBox(
                  child: MoveWindow(),
                ),*/
                //Text("hola"),
                //Text("hola"),
                const WindowButtons(),
              ],
            ),
            Expanded(
              // Utiliza Expanded aquí para que el Column ocupe todo el espacio vertical disponible
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Colors.red,
                      )
                    ],
                  ),
                  LeftSide(),
                  RightSide(),
                ],
              ),
            ),
          ],
        ));
  }
}

/*WindowTitleBarBox(
                  child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  const WindowButtons()
                ],
              )),*/

class LeftSide extends StatelessWidget {
  const LeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 2, 34, 14), // Color del borde
          width: 0.2, // Ancho del borde
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            sideBarColor,
            const Color.fromARGB(255, 33, 109, 72),
            const Color.fromARGB(255, 48, 87, 3)
          ],
        ),
      ),
      child: Column(
        children: [
          WindowTitleBarBox(
            child: MoveWindow(),
          ),
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

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  DropDownCategories createState() => DropDownCategories();
}

class DropDownCategories extends State<DropdownWidget> {
  String currentItem = "";
  List<String> items = ['Opción 1', 'Opción 2', 'Opción 3', 'Opción 4'];

  @override
  void initState() {
    currentItem = items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 10), // Margen izquierdo deseado
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: const Color.fromARGB(90, 28, 102, 50),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(),
        ),
        child: DropdownButton(
          underline: Container(),
          style: TextStyle(
              fontSize: 14, color: const Color.fromARGB(255, 36, 29, 29)),
          isExpanded:
              true, // Hace que el DropdownButton ocupe todo el ancho disponible
          alignment: Alignment.topCenter,
          borderRadius: BorderRadius.circular(8),
          dropdownColor: const Color.fromARGB(255, 45, 114, 72),
          value: currentItem,
          onChanged: (String? newValue) {
            setState(() {
              currentItem = newValue ?? "";
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              alignment: Alignment.topLeft,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class RightSide extends StatelessWidget {
  const RightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundStartColor,
                backgroundEndColor,
                const Color.fromARGB(255, 48, 87, 3)
              ],
            ),
          ),
          child: Column(
            children: [
              ArcadeBoxButtonWidget(),
            ],
          )),
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
