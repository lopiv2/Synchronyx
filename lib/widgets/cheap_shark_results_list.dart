import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lioncade/models/responses/cheapSharkResponse_response.dart';
import 'package:lioncade/utilities/generic_api_functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheapSharkResultsList extends StatelessWidget {
  final String title;
  const CheapSharkResultsList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    List<CheapSharkResponse> responses = [];
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    bool isHovered = false; // Variable to track whether hover is being made
    return SingleChildScrollView(
        child: Column(children: [
      Container(
          height: MediaQuery.of(context).size.height * 0.195,
          child: FutureBuilder<List<CheapSharkResponse>>(
              future: DioClient().getDealsFromCheapShark(title: title),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CheapSharkResponse>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Transform.scale(
                      scale:
                          1, // Adjusts the scaling value to make the CircularProgressIndicator smaller.
                      child: const CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData ||
                    snapshot.data!.isEmpty ||
                    snapshot.data == null) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        appLocalizations.dealsNotFound),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        appLocalizations.dealsNotFound),
                  );
                } else {
                  responses = snapshot.data!;
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: responses.length,
                      itemBuilder: (BuildContext context, int index) {
                        final cheapSharkResponse = responses[index];
                        return InkWell(
                          onTap: () async {
                            final url =
                                'https://www.cheapshark.com/redirect?dealID={${cheapSharkResponse.dealId}}';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Can´t open URI $url';
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                30,
                                MediaQuery.of(context).size.height * 0.01,
                                30,
                                0),
                            child: Table(
                              border: const TableBorder(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          height: 55,
                                          imageUrl: cheapSharkResponse.logo,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/icons/noimage.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Text(
                                        cheapSharkResponse.store.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Text(
                                        '${cheapSharkResponse.retailPrice} €',
                                        textAlign: TextAlign.center,
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
                                      child: Container(
                                        color: Colors.green,
                                        child: Text(
                                          '${cheapSharkResponse.salePrice} €',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
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
