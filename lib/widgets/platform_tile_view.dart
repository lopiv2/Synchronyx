import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:lioncade/models/platforms.dart';
import 'package:lioncade/widgets/buttons/custom_folder_button.dart';

class PlatformTreeTile extends StatelessWidget {
  const PlatformTreeTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onMouseEnter,
    required this.onMouseExit,
    required this.isMouseOver,
  });

  final TreeEntry<Platforms> entry;
  final VoidCallback onTap;
  final VoidCallback onMouseEnter;
  final VoidCallback onMouseExit;
  final bool isMouseOver;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) {
          onMouseEnter();
        },
        onExit: (_) {
          onMouseExit();
        },
        child: InkWell(
          onTap: onTap,
          // Wrap your content in a TreeIndentation widget which will properly
          // indent your nodes (and paint guides, if required).
          //
          // If you don't want to display indent guides, you could replace this
          // TreeIndentation with a Padding widget, providing a padding of
          // `EdgeInsetsDirectional.only(start: TreeEntry.level * indentAmount)`
          /*child: Padding(
          padding: EdgeInsetsDirectional.only(start: TreeEntry.level * 2),
        )*/
          child: TreeIndentation(
            entry: entry,
            // Provide an indent guide if desired. Indent guides can be used to
            // add decorations to the indentation of tree nodes.
            // This could also be provided through a DefaultTreeIndentGuide
            // inherited widget placed above the tree view.
            guide: const IndentGuide.connectingLines(indent: 25),
            // The widget to render next to the indentation. TreeIndentation
            // respects the text direction of `Directionality.maybeOf(context)`
            // and defaults to left-to-right.
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Add a widget to indicate the expansion state of this node.
                  // See also: ExpandIcon.
                  Expanded(
                    flex: 1,
                    child: Container(
                        decoration: BoxDecoration(
                          color: isMouseOver ? const Color.fromARGB(87, 33, 149, 243) : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                              8), // Ajusta el radio del borde según tus necesidades
                        ),
                        child: CustomFolderButton(
                          hoverColor: Colors.blue,
                          icon: entry.node.icon,
                          title: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color:
                                    isMouseOver ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                              text: entry.node.title,
                            ),
                          ),
                          //iconSize: 80,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          closedIcon: const Icon(
                            Icons.arrow_right,
                          ),
                          openedIcon: const Icon(
                            Icons.arrow_drop_down,
                          ),
                          isOpen: entry.hasChildren ? entry.isExpanded : null,
                          onPressed: onTap,
                        )), // Add spacing between icons
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
