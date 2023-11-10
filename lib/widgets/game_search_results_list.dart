import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/models/responses/rawg_response.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/widgets/buttons/text_button_colored.dart';

class RawgResponseListWidget extends StatelessWidget {
  final List<RawgResponse> rawgResponses;

  RawgResponseListWidget({required this.rawgResponses});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Padding(
        padding:
            const EdgeInsets.all(10.0), // Agrega un padding de 16 en todos los lados
        child: Container(
          height: MediaQuery.of(context).size.height *
              0.8, // Define la altura deseada
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.green, // Color del borde gris
              width: 1.0, // Grosor del borde
            ),
          ),
          child: ListView.builder(
            itemCount: rawgResponses.length,
            itemExtent: MediaQuery.of(context).size.height * 0.07,
            itemBuilder: (context, index) {
              final rawgResponse = rawgResponses[index];
              return ListTile(
                leading: SizedBox(
                    width: 24, // Ancho deseado para la imagen
                    child: CachedNetworkImage(
                      imageUrl: rawgResponse.iconUrl ?? '',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/icons/noimage.png'),
                    )),
                minLeadingWidth: 0,
                title: TextButtonHoverColored(
                    enableEllipsis: true,
                    onPressed: (() => {
                          appState.selectedGame = null,
                          appState.enableGameSearchViewPanel(true),
                          appState.gameClicked = rawgResponse,
                        }),
                    text: rawgResponse.name ?? ''),
                dense: true,
              );
            },
          ),
        ),
      );
    });
  }
}
