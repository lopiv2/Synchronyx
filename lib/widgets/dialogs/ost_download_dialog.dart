import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/models/responses/khinsider_response.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/utilities/generic_api_functions.dart';

class OstDownloadDialog extends StatelessWidget {
  const OstDownloadDialog({super.key, required this.appLocalizations});
  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    String title = appState.selectedGame!.game.title;
    List<KhinsiderResponse> responses = [];
    final GlobalKey _dialogKey = GlobalKey();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 2, 34, 14),
            width: 0.2,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Constants.SIDE_BAR_COLOR,
              Color.fromARGB(255, 33, 109, 72),
              Color.fromARGB(255, 48, 87, 3),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Constants.SIDE_BAR_COLOR,
                    elevation: 0.0,
                    toolbarHeight: 35.0,
                    titleSpacing: -20.0,
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.abc,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Titulo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Text(
                      "Importar audio para ${appState.selectedGame!.game.title}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Resultados',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        FutureBuilder<List<KhinsiderResponse>>(
                          future: DioClient().scrapeKhinsider(title: title),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<KhinsiderResponse>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('No se encontraron resultados');
                            } else {
                              return SingleChildScrollView(
                                  child: Table(
                                border: TableBorder.all(color: Colors.grey),
                                defaultColumnWidth: FixedColumnWidth(150.0),
                                children:
                                    snapshot.data!.map((khinsiderResponse) {
                                  return TableRow(
                                    children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child:
                                            Text(khinsiderResponse.nameAlbum),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child:
                                            Text(khinsiderResponse.platform!),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Text(
                                          khinsiderResponse.year.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: ElevatedButton(
                                          child: Text(
                                              appState.showMoreContent == false
                                                  ? 'Seleccionar'
                                                  : 'Más'),
                                          onPressed: () {
                                            // Usa el Provider para cambiar el estado de mostrar/ocultar contenido.
                                            appState.toggleShowMoreContent();
                                            print(appState.showMoreContent);
                                          }, // Agrega el botón "Más" aquí
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Consumer<AppState>(
                      builder: (context, moreContentProvider, child) {
                    return Container(
                      height: 200,
                      child: Visibility(
                        visible: appState.showMoreContent,
                        child: Column(
                          children: [
                            // Aquí puedes construir la lista de elementos que deseas mostrar
                            // Puedes usar un ListView.builder u otro widget apropiado
                            for (int i = 0; i < 4; i++)
                              ListTile(
                                title: Text('Elemento $i'),
                              ),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromARGB(255, 48, 87, 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(appLocalizations.back),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Change the button color to red
                          ),
                          child: Text(appLocalizations.cancel),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
