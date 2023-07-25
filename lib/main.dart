import 'package:flutter/material.dart';
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

var sideBarColor = Colors.amber;
var backgroundStartColor = Colors.amberAccent;
var backgroundEndColor = Colors.orange;

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
    return Row(
      children: [
        LeftSide(),
        RightSide(),
      ],
    );
  }
}

class LeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
          color: sideBarColor,
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
              const Row(
                children: <Widget>[
                  SizedBox(width: 10), // give it width
                  Flexible(
                      child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.amber,
                      border:
                          OutlineInputBorder(), // Aquí establecemos el borde
                      hintText: 'Search', // Texto de ayuda dentro del TextField
                      // Otros estilos de la decoración (opcional)
                      // labelStyle: TextStyle(color: Colors.red),
                      // hintStyle: TextStyle(color: Colors.grey),
                    ),
                  )),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              DropdownWidget(),
            ],
          )),
    );
  }
}

class DropdownWidget extends StatefulWidget {
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: DropdownButton(
        alignment: Alignment.topCenter,
        borderRadius: BorderRadius.circular(8),
        dropdownColor: Colors.blueAccent,
        value: currentItem,
        onChanged: (String? newValue) {
          setState(() {
            currentItem = newValue ?? "";
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: Alignment.center,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class RightSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [backgroundStartColor, backgroundEndColor],
                stops: const [0.0, 1.0]),
          ),
          child: Column(
            children: [
              WindowTitleBarBox(
                  child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  WindowButtons()
                ],
              ))
            ],
          )),
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      MinimizeWindowButton(),
      MaximizeWindowButton(),
      CloseWindowButton()
    ]);
  }
}
