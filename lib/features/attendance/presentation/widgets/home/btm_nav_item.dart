import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../../core/common/entities/menu.dart';
import 'animated_bar.dart';

class BtmNavItem extends StatelessWidget {
  const BtmNavItem(
      {super.key,
      required this.navBar,
      required this.press,
      required this.riveOnInit,
      required this.selectedNav});

  final Menu navBar;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedNav;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBar(isActive: selectedNav == navBar),
          SizedBox(
            height: 36,
            width: size.width * 0.15,
            child: Opacity(
              opacity: selectedNav == navBar ? 1 : 0.5,
              child: RiveAnimation.asset(
                navBar.rive.src,
                artboard: navBar.rive.artboard,
                onInit: riveOnInit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
