import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:synchronyx/models/responses/cheapSharkResponse_response.dart';
import 'package:synchronyx/utilities/generic_api_functions.dart';

class CheapSharkResultsList extends StatelessWidget {
  final String title;
  const CheapSharkResultsList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    List<CheapSharkResponse> responses = [];
    return SingleChildScrollView(
        child: Column(children: [
      Container(
          height: MediaQuery.of(context).size.height * 0.225,
          child: FutureBuilder<List<CheapSharkResponse>>(
              future: DioClient().getDealsFromCheapShark(title: title),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CheapSharkResponse>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Center(
                      child: Transform.scale(
                        scale:
                            1, // Adjusts the scaling value to make the CircularProgressIndicator smaller.
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No se encontraron resultados');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No se encontraron resultados');
                } else {
                  responses = snapshot.data!;
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: responses.length,
                      itemBuilder: (BuildContext context, int index) {
                        final cheapSharkResponse = responses[index];
                        return InkWell(
                          onTap: () {
                            // Maneja la acción cuando se hace clic en la fila aquí
                            print('Fila clickeada en el índice $index');
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Table(
                              border: TableBorder.all(color: Colors.grey),
                              defaultColumnWidth: FixedColumnWidth(
                                  MediaQuery.of(context).size.width * 0.098),
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: CachedNetworkImage(
                                        height: 55,
                                        imageUrl: cheapSharkResponse.logo,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/icons/noimage.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Text(
                                        cheapSharkResponse.store.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Text(
                                        '${cheapSharkResponse.salePrice} €',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Text(
                                        '${cheapSharkResponse.retailPrice} €',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }))
    ]));
  }
}
