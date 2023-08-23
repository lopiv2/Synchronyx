import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/widgets/platform_tile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/platforms.dart';
import '../utilities/Constants.dart';
import 'package:collection/collection.dart';
import '../utilities/generic_functions.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;

class PlatformTreeView extends StatefulWidget {
  final AppLocalizations appLocalizations;
  const PlatformTreeView({super.key, required this.appLocalizations});

  @override
  State<PlatformTreeView> createState() => _PlatformTreeViewState();
}

class _PlatformTreeViewState extends State<PlatformTreeView> {
  late final TreeController<Platforms> treeController;
  static List<Platforms> roots = [];

  final Map<TreeEntry<Platforms>, bool> nodeMouseOverMap = {};

  void updateNodeMouseOver(TreeEntry<Platforms> entry, bool isMouseOver) {
    setState(() {
      nodeMouseOverMap[entry] = isMouseOver;
    });
  }

  @override
  void initState() {
    super.initState();
    roots = buildTreeView();

    treeController = TreeController<Platforms>(
      // Provide the root nodes that will be used as a starting point when
      // traversing your hierarchical data.
      roots: roots,
      // Provide a callback for the controller to get the children of a
      // given node when traversing your hierarchical data. Avoid doing
      // heavy computations in this method, it should behave like a getter.
      childrenProvider: (Platforms node) => node.children,
    );
  }

  List<Platforms> buildTreeView() {
    final appState = Provider.of<AppState>(context, listen: false);
    List<String> platformsList = appState.gamesInGrid
        .map((gameResponse) => gameResponse.game.platform)
        .toSet()
        .toList();
    List<Platforms> platformsNodes = [];
    Platforms f = Platforms(
        title: widget.appLocalizations.all,
        value: GamePlatforms.All.name,
        icon: GamePlatforms.All.image);
    platformsNodes.add(f);
    for (var platform in platformsList) {
      //Si hay alguna plataforma de ordenador, busco a ver si existe el padre Ordenadores
      if (platform == "Windows" || platform == "Linux" || platform == "Mac") {
        Platforms? comp = platformsNodes.firstWhereOrNull(
          (element) => element.value == GamePlatforms.Computers.name,
        );
        //si no hay computers, lo creo
        if (comp == null) {
          comp = Platforms(
              title: widget.appLocalizations.computers,
              value: GamePlatforms.Computers.name,
              icon: GamePlatforms.Computers.image);
          platformsNodes.add(comp);
        }
        //Si ya existe, simplemente añado el hijo
        GamePlatforms g = GamePlatforms.values
            .firstWhere((element) => element.name == platform);
        //Creo el hijo
        Platforms p = Platforms(title: g.name, value: g.name, icon: g.image);
        //Añado el hijo al padre
        comp.children.add(p);
      }
    }
    return platformsNodes;
  }

  @override
  void dispose() {
    // Remember to dispose your tree controller to release resources.
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This package provides some different tree views to customize how
    // your hierarchical data is incorporated into your app. In this example,
    // a TreeView is used which has no custom behaviors, if you wanted your
    // tree nodes to animate in and out when the parent node is expanded
    // and collapsed, the AnimatedTreeView could be used instead.
    //
    // The tree view widgets also have a Sliver variant to make it easy
    // to incorporate your hierarchical data in sophisticated scrolling
    // experiences.
    return TreeView<Platforms>(
      // This controller is used by tree views to build a flat representation
      // of a tree structure so it can be lazy rendered by a SliverList.
      // It is also used to store and manipulate the different states of the
      // tree nodes.
      treeController: treeController,
      // Provide a widget builder callback to map your tree nodes into widgets.
      nodeBuilder: (BuildContext context, TreeEntry<Platforms> entry) {
        // Provide a widget to display your tree nodes in the tree view.
        //
        // Can be any widget, just make sure to include a [TreeIndentation]
        // within its widget subtree to properly indent your tree nodes.
        return PlatformTreeTile(
          // Add a key to your tiles to avoid syncing descendant animations.
          key: ValueKey(entry.node),
          // Your tree nodes are wrapped in TreeEntry instances when traversing
          // the tree, these objects hold important details about its node
          // relative to the tree, like: expansion state, level, parent, etc.
          //
          // TreeEntrys are short lived, each time TreeController.rebuild is
          // called, a new TreeEntry is created for each node so its properties
          // are always up to date.
          entry: entry,
          // Add a callback to toggle the expansion state of this node.
          isMouseOver: nodeMouseOverMap[entry] ?? false,
          onMouseEnter: () {
            updateNodeMouseOver(entry, true);
          },
          onMouseExit: () {
            updateNodeMouseOver(entry, false);
          },
          onTap: () => {
            treeController.toggleExpansion(entry.node),
            print(entry.node.title)
          },
        );
      },
    );
  }
}
