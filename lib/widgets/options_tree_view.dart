import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/widgets/options_tile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/Options.dart';

class OptionsTreeView extends StatefulWidget {
  final AppLocalizations appLocalizations;
  const OptionsTreeView({super.key, required this.appLocalizations});

  @override
  State<OptionsTreeView> createState() => _OptionsTreeViewState();
}

class _OptionsTreeViewState extends State<OptionsTreeView> {
  late final TreeController<Options> treeController;
  static List<Options> roots = [];

  final Map<TreeEntry<Options>, bool> nodeMouseOverMap = {};

  void updateNodeMouseOver(TreeEntry<Options> entry, bool isMouseOver) {
    setState(() {
      nodeMouseOverMap[entry] = isMouseOver;
    });
  }

  @override
  void initState() {
    super.initState();
    roots = buildTreeView();

    treeController = TreeController<Options>(
      // Provide the root nodes that will be used as a starting point when
      // traversing your hierarchical data.
      roots: roots,
      // Provide a callback for the controller to get the children of a
      // given node when traversing your hierarchical data. Avoid doing
      // heavy computations in this method, it should behave like a getter.
      childrenProvider: (Options node) => node.children,
    );
  }

  List<Options> buildTreeView() {
    /*List<String> optionsList = [];
    optionsList.add('General');*/
    List<Options> optionsNodes = [];
    Options g = Options(
        title: widget.appLocalizations.optionsGeneralTitle, value: 'general');
    optionsNodes.add(g);
    Options v = Options(
        title: widget.appLocalizations.optionsVisualsTitle, value: 'visual');
    optionsNodes.add(v);
    g.children.add(Options(
        title: widget.appLocalizations.optionsPreferencesTitle,
        value: 'prefs'));
    v.children.add(Options(
        title: widget.appLocalizations.optionsGameTitle, value: 'games'));
    v.children.add(
        Options(title: widget.appLocalizations.tabCalendar, value: 'calendar'));
    v.children.add(
        Options(title: widget.appLocalizations.optionsThemeTitle, value: 'theme'));
    return optionsNodes;
  }

  @override
  void dispose() {
    // Remember to dispose your tree controller to release resources.
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    // This package provides some different tree views to customize how
    // your hierarchical data is incorporated into your app. In this example,
    // a TreeView is used which has no custom behaviors, if you wanted your
    // tree nodes to animate in and out when the parent node is expanded
    // and collapsed, the AnimatedTreeView could be used instead.
    //
    // The tree view widgets also have a Sliver variant to make it easy
    // to incorporate your hierarchical data in sophisticated scrolling
    // experiences.
    return TreeView<Options>(
      // This controller is used by tree views to build a flat representation
      // of a tree structure so it can be lazy rendered by a SliverList.
      // It is also used to store and manipulate the different states of the
      // tree nodes.
      treeController: treeController,
      // Provide a widget builder callback to map your tree nodes into widgets.
      nodeBuilder: (BuildContext context, TreeEntry<Options> entry) {
        // Provide a widget to display your tree nodes in the tree view.
        //
        // Can be any widget, just make sure to include a [TreeIndentation]
        // within its widget subtree to properly indent your tree nodes.
        return OptionsTreeTile(
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
                  appState.selectedOptionClicked.value = entry.node.value
                });
      },
    );
  }
}
