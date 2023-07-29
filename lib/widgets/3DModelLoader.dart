import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class ModelLoader extends StatefulWidget {
  const ModelLoader();

  @override
  _ModelLoader createState() => _ModelLoader();
}

class _ModelLoader extends State<ModelLoader>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _bunny;
  late AnimationController _controller;
  double _ambient = 0.1;
  double _diffuse = 0.8;
  double _specular = 0.5;
  double _shininess = 0.0;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    //scene.camera.position.z = 10;
    scene.camera.zoom = 1;
    scene.light.position.setFrom(Vector3(0, 10, 10));
    scene.light.setColor(Colors.white, _ambient, _diffuse, _specular);
    _bunny = Object(
        position: Vector3(0, 0, 0),
        scale: Vector3(5.0, 5.0, 5.0),
        lighting: true,
        fileName: 'assets/models/Plank_07.obj');
    scene.world.add(_bunny!);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_bunny != null) {
          _bunny!.rotation.y = _controller.value * 360;
          _bunny!.updateTransform();
          _scene.update();
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onModelTapped() {
    // Aquí puedes realizar alguna acción cuando el modelo es clicado.
    print('Modelo 3D clicado!');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {}, // Evitar el zoom
        //onPanUpdate: (DragUpdateDetails details) {}, // Evitar el paneo
        onDoubleTap: () {}, // Evitar la rotación al doble tocar
        onTap: onModelTapped,
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ));
  }
}
