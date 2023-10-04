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
                      child: Table(
                    border: TableBorder.all(color: Colors.grey),
                    defaultColumnWidth: FixedColumnWidth(
                        MediaQuery.of(context).size.width * 0.098),
                    children: responses.map((cheapSharkResponse) {
                      print(cheapSharkResponse.logo);
                      final currentIndex =
                          responses.indexOf(cheapSharkResponse);
                      return TableRow(
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
                                  Image.asset('assets/icons/noimage.png'),
                              fit: BoxFit
                                  .fitWidth, // Ajusta la imagen para cubrir todo el contenedor
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                cheapSharkResponse.store.toString()),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                '${cheapSharkResponse.salePrice} €'),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                '${cheapSharkResponse.retailPrice} €'),
                          ),
                        ],
                      );
                    }).toList(),
                  ));
                }
              }))
    ]));
  }
}
