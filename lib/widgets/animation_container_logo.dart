import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/providers/app_state.dart';

class AnimationLogoContainer extends StatelessWidget { 
  const AnimationLogoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //Logo
    ImageProvider<Object> logoWidgetMarquee;
    logoWidgetMarquee = FileImage(File(appState.selectedGame!.media.logoUrl));
    return Container(
      // ignore: use_build_context_synchronously
      width: MediaQuery.of(context).size.width * 0.15,
      // ignore: use_build_context_synchronously
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: logoWidgetMarquee,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
