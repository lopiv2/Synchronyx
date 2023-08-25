import 'package:flutter/material.dart';

class FavoriteFilterColumn extends StatelessWidget {
  const FavoriteFilterColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
                10, 20, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Acción del primer botón
                  },
                  child: Text('Todo'),
                ),
                SizedBox(height: 20), // Espacio entre botones
                ElevatedButton(
                  onPressed: () {
                    // Acción del segundo botón
                  },
                  child: Text('No'),
                ),
                SizedBox(height: 20), // Espacio entre botones
                ElevatedButton(
                  onPressed: () {
                    // Acción del tercer botón
                  },
                  child: Text('Si'),
                ),
              ],
            )));
  }
}
