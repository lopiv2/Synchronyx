import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronyx/models/event.dart';
import 'package:synchronyx/models/global_options.dart';
import 'package:synchronyx/models/responses/rawg_response.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/app_directory_singleton.dart';
import 'package:synchronyx/utilities/audio_singleton.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as database;
import 'package:synchronyx/utilities/generic_database_functions.dart';
import 'package:synchronyx/widgets/buttons/notification_button.dart';
import 'package:synchronyx/widgets/calendar_view_events.dart';
import 'package:synchronyx/widgets/clicked_game_favorite_view.dart';
import 'package:synchronyx/widgets/filter_info_panel.dart';
import 'package:synchronyx/widgets/filters/all_filter.dart';
import 'package:synchronyx/widgets/filters/favorite_filter.dart';
import 'package:synchronyx/widgets/filters/owned_filter.dart';
import 'package:synchronyx/widgets/game_info_panel.dart';
import 'package:synchronyx/widgets/game_search_results_list.dart';
import 'package:synchronyx/widgets/grid_view_game_covers_buyable.dart';
import 'package:synchronyx/widgets/platform_tree_view.dart';
import 'package:synchronyx/widgets/top_menu_bar.dart';
import 'widgets/buttons/arcade_box_button.dart';
import 'widgets/drop_down_filter_order_games.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'widgets/grid_view_game_covers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/utilities/generic_api_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDirectories.instance.initialize();
  runApp(MultiProvider(providers: [
    //ChangeNotifierProvider(create: (_) => TrackListState()),
    ChangeNotifierProvider(create: (_) => AppState()),
  ], child: const MyApp()));

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1024, 768);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Synchronyx";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Esta línea elimina el banner de depuración
      title: 'Synchronyx Game Launcher',
      localizationsDelegates:
          AppLocalizations.localizationsDelegates, // Cambio aquí
      supportedLocales: AppLocalizations.supportedLocales,
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
        body: MainGrid(context: context),
      ),
    );
  }
}

// ignore: must_be_immutable
class MainGrid extends StatefulWidget {
  final BuildContext context;
  bool isLoading=false;

  MainGrid({super.key, required this.context, this.isLoading=false});

  @override
  State<MainGrid> createState() => _MainGridState();
}

class _MainGridState extends State<MainGrid>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    final appState = Provider.of<AppState>(context, listen: false);
    if (_tabController.index != selectedTabIndex) {
      selectedTabIndex = _tabController.index;
      if (_tabController.index == 0) {
        appState.toggleGameSearch(false);
        appState.updateSelectedGame(null);
      } else if (_tabController.index == 1) {
        appState.resetFilter();
        appState.toggleGameSearch(true);
        appState.updateSelectedGame(null);
      } else if (_tabController.index == 2) {
        appState.resetFilter();
        appState.updateSelectedGame(null);
        appState.toggleGameSearch(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final appState = Provider.of<AppState>(context);
    final AudioManager audioManager = AudioManager();
    late File imageFile;
    if (appState.selectedGame == null) {
      audioManager.stop();
    }
    int eventCounterNotifications = 0;
    return FutureBuilder<Database?>(
        future: database.createAndOpenDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null) {
            return const Text('The database was not initialized correctly.');
          } else {
            Constants.database = snapshot.data;
            // ignore: unused_local_variable
            return FutureBuilder<GlobalOptions?>(
                future: getOptions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data != null) {
                    appState.selectedOptions = snapshot.data!;
                    appState.optionsResponse =
                        GlobalOptions.copy(snapshot.data!);
                    imageFile = File(
                        appState.optionsResponse.imageBackgroundFile ?? '');
                  }
                  return FutureBuilder<List<Event>>(
                      future: getAllEvents(),
                      builder: (context, eventsSnapshot) {
                        if (eventsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (eventsSnapshot.hasError) {
                          return Text('Error: ${eventsSnapshot.error}');
                        } else if (!eventsSnapshot.hasData) {
                          return const Text('Cargando contenedores...');
                        } else {
                          List<Event> eventsList = eventsSnapshot.data!;
                          appState.addAllEvents(eventsList);
                          return Container(
                            color: Constants.SIDE_BAR_COLOR,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyMenuBar(
                                        appLocalizations: appLocalizations),
                                    Expanded(
                                      flex: 2,
                                      child: WindowTitleBarBox(
                                        child: MoveWindow(),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ArcadeBoxButtonWidget(),
                                              NotificationButtonWidget(
                                                appState: appState,
                                                eventsList: eventsList,
                                              )
                                            ])),
                                    const WindowButtons(),
                                  ],
                                ),
                                Expanded(
                                  // Utiliza Expanded aquí para que el Column ocupe todo el espacio vertical disponible
                                  child: Row(
                                    children: [
                                      LeftSide(
                                          appLocalizations: appLocalizations),
                                      CenterSide(
                                        tabController: _tabController,
                                        imageFile: imageFile,
                                      ),
                                      RightSide(
                                          appLocalizations: appLocalizations),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                });
          }
        });
  }
}

class LeftSide extends StatefulWidget {
  final AppLocalizations appLocalizations;

  const LeftSide({Key? key, required this.appLocalizations}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LeftSideState createState() => _LeftSideState();
}

class _LeftSideState extends State<LeftSide> {
  SearchParametersDropDown? selectedValue = SearchParametersDropDown.Owned;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Container(
        width: MediaQuery.of(context).size.width * 0.18,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 2, 34, 14), // Color del borde
            width: 0.2, // Ancho del borde
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Constants.SIDE_BAR_COLOR,
              Color.fromARGB(255, 33, 109, 72),
              Color.fromARGB(255, 48, 87, 3)
            ],
          ),
        ),
        child: Consumer<AppState>(builder: (context, appState, child) {
          return Column(children: [
            //Padding(padding: EdgeInsets.only(top: 10.0)),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              height: 30,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 10), // give it width
                  Flexible(
                      child: Stack(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 6),
                          filled: true,
                          fillColor: const Color.fromARGB(127, 11, 129, 46),
                          border: const OutlineInputBorder(),
                          hintText: appState.searchGameEnabled
                              ? widget.appLocalizations.searchInternet
                              : widget.appLocalizations.searchLibrary,
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSubmitted: (String searchString) async {
                          if (appState.searchGameEnabled) {
                            handleSearchInternetButtonPress(
                                context, searchString, widget.appLocalizations);
                          } else {
                            searchByString(searchString);
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          padding: const EdgeInsets.only(
                              top: 2), // Ajusta la posición vertical del icono
                          onPressed: () {
                            if (appState.searchGameEnabled) {
                              handleSearchInternetButtonPress(
                                  context,
                                  searchController.text,
                                  widget.appLocalizations);
                            } else {
                              searchByString(searchController.text);
                            }
                          },
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Visibility(
              visible: appState.searchGameEnabled == false,
              child: DropdownWidget(
                indexInitialValue: appState.filterIndex,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
              ),
            ),
            Visibility(
                visible: appState.searchGameEnabled && appState.resultsEnabled,
                child: RawgResponseListWidget(
                  rawgResponses: appState.results,
                )),
            Expanded(
              child: _buildWidgetBasedOnSelectedValue(
                  Provider.of<AppState>(context)),
            ),
          ]);
        }));
  }

  Widget _buildWidgetBasedOnSelectedValue(AppState appState) {
    switch (selectedValue?.caseValue) {
      case 'all':
        if (appState.filterIndex == 1) {
          return AllFilterColumn(appLocalizations: widget.appLocalizations);
        } else {
          return const Text('');
        }
      case 'categoryPlatform':
        if (appState.filterIndex == 2) {
          return PlatformTreeView(appLocalizations: widget.appLocalizations);
        } else {
          return const Text('');
        }
      case 'favorite':
        if (appState.filterIndex == 4) {
          return FavoriteFilterColumn(
              appLocalizations: widget.appLocalizations);
        } else {
          return const Text('');
        }
      case 'owned':
        if (appState.searchGameEnabled == false) {
          return OwnedFilterColumn(appLocalizations: widget.appLocalizations);
        } else {
          return const Text('');
        }
      default:
        return const Text(
            ""); // Cambia YourDefaultWidget por el widget predeterminado
    }
  }

  Future<void> handleSearchInternetButtonPress(BuildContext context,
      String searchString, AppLocalizations appLocalizations) async {
    final appState = Provider.of<AppState>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Text(
              style: const TextStyle(fontWeight: FontWeight.bold),
              appLocalizations.searchingGames,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );

    List<RawgResponse> responses = [];
    final dio = DioClient();
    responses = await dio.searchGamesRawg(
        key: '68239c29cb2c49f2acfddf9703077032', searchString: searchString);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Cierra el diálogo

    if (responses.isNotEmpty) {
      appState.showResults(responses, true);
    } else {
      const Text("No results");
    }
  }

  void searchByString(String searchString) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateFilters('search', searchString);
    appState.updateSelectedGame(null);
    appState.refreshGridView();
  }
}

class CenterSide extends StatefulWidget {
  File imageFile;
  final TabController tabController;
  CenterSide({super.key, required this.imageFile, required this.tabController});

  @override
  // ignore: library_private_types_in_public_api
  _CenterSideState createState() => _CenterSideState();
}

class _CenterSideState extends State<CenterSide>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    widget.imageFile = File(appState.optionsResponse.imageBackgroundFile ?? '');
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: appState.optionsResponse.showBackgroundImageCalendar == 1 &&
                  widget.tabController.index == 2
              ? DecorationImage(
                  image: FileImage(widget.imageFile),
                  fit: BoxFit.cover,
                )
              : null,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Constants.BACKGROUND_START_COLOR,
              Constants.BACKGROUND_END_COLOR,
              Color.fromARGB(255, 48, 87, 3)
            ],
          ),
        ),
        child: Column(
          children: [
            TabBar(
              controller: widget.tabController,
              tabs: [
                Tab(text: appLocalizations.tabLibrary),
                Tab(text: appLocalizations.tabShopList),
                Tab(text: appLocalizations.tabCalendar),
              ],
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 4.0,
                    color: Colors.blue), // Indicator thickness and color
                insets:
                    EdgeInsets.symmetric(horizontal: 16.0), // Indicator width
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: widget.tabController,
                children: [
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      return const GridViewGameCovers(); // Contents of the 'Library' tab
                    },
                  ),
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      return appState.enableGameSearchView == false
                          ? const GridViewGameCoversBuyable()
                          : ClickedGameBuyableView(
                              game: appState
                                  .gameClicked); // Contents of the 'List' tab
                    },
                  ),
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      final eventController = appState.eventController;
                      return CalendarViewEvents(
                        controller: eventController,
                      ); // Contents of the 'Calendar' tab
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightSide extends StatefulWidget {
  final AppLocalizations appLocalizations;
  RightSide({Key? key, required this.appLocalizations}) : super(key: key);

  @override
  State<RightSide> createState() => _RightSideState();
}

class _RightSideState extends State<RightSide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 2, 34, 14), // Color del borde
          width: 0.2, // Ancho del borde
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Constants.SIDE_BAR_COLOR,
            Color.fromARGB(255, 33, 109, 72),
            Color.fromARGB(255, 48, 87, 3)
          ],
        ),
      ),
      child: provider.Consumer<AppState>(
        builder: (context, appState, child) {
          return appState.selectedGame != null
              ? GameInfoPanel(
                  appLocalizations: widget.appLocalizations,
                )
              : FilterInfoPanel(appLocalizations: widget.appLocalizations);
        },
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      MinimizeWindowButton(),
      MaximizeWindowButton(),
      CloseWindowButton()
    ]);
  }
}
