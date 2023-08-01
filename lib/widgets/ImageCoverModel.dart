import 'package:flutter/material.dart';
import 'dart:math';

class ImageCoverModel extends StatefulWidget {
  const ImageCoverModel();

  @override
  _ImageCoverModel createState() => _ImageCoverModel();
}

class _ImageCoverModel extends State<ImageCoverModel>
    with SingleTickerProviderStateMixin {
  bool isMouseOver = false;
  late AnimationController _animationController;
  double rotationAngleY = 0.0;

  bool showAdditionalOverlay =
      false; // Variable para controlar la visibilidad de la imagen overlay adicional

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.addListener(() {
      // Detectar cuando la animación ha finalizado y cambiar el estado de showAdditionalOverlay
      if (_animationController.value > 0.5) {
        setState(() {
          showAdditionalOverlay = true;
          print("hola");
        });
      } else if (_animationController.status == AnimationStatus.dismissed) {
        setState(() {
          showAdditionalOverlay = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isMouseOver = true;
          _animationController.forward();
        });
      },
      onExit: (_) {
        setState(() {
          isMouseOver = false;
          _animationController.reverse();
          showAdditionalOverlay = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          print('Tapped');
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0018) // Aplicar una perspectiva 3D
                ..rotateX(0.2) // Rotación en el eje x
                ..rotateY(isMouseOver
                    ? _animationController.value * 3.45
                    : 0.4), // Rotación en el eje y (45 grados si el ratón está sobre el widget, 0 grados si no)
              child: Stack(
                children: [
                  Image.asset(
                    'assets/models/PS2WII.png',
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.9,
                    fit: BoxFit.contain,
                  ), // Imagen de fondo
                  Positioned.fill(
                    left: 0,
                    bottom: 0,
                    child: Transform.scale(
                      scale:
                          0.395, // Ajusta el tamaño del botón (50% en este ejemplo)
                      child: Container(
                        height: 100, //height of button
                        width:
                            3000, // Ancho deseado del botón (puedes ajustarlo según tus necesidades)
                        child: MaterialButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          splashColor: Colors.red,
                          elevation: 8.0,
                          onPressed: () {
                            print('Tapped');
                          },
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2,
                                  0.0018) // Aplicar una perspectiva 3D adicional a la imagen overlay
                              ..rotateX(
                                  0) // Rotación en el eje x de la imagen overlay (15 grados si el ratón está sobre el widget, 0 grados si no)
                              ..rotateY(
                                  0), // Rotación en el eje y de la imagen overlay (60 grados si el ratón está sobre el widget, 0 grados si no)
                            alignment: Alignment.center,
                            child: AspectRatio(
                              aspectRatio: 8.5 /
                                  12, // Relación de aspecto deseada (16:9 en este ejemplo)
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/frontcover.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Visibility(
                      visible: showAdditionalOverlay,
                      child: AspectRatio(
                        aspectRatio: 8.5 /
                            12, // Relación de aspecto deseada (16:9 en este ejemplo)
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/backcover.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
