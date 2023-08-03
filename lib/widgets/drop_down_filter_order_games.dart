import 'package:flutter/material.dart';

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
