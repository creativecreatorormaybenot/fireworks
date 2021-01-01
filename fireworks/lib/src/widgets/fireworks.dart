import 'package:fireworks/src/foundation/controller.dart';
import 'package:fireworks/src/rendering/fireworks.dart';
import 'package:flutter/widgets.dart';

class Fireworks extends LeafRenderObjectWidget {
  Fireworks({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final FireworkController controller;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFireworks(
      controller: controller,
    );
  }

  // todo(creativecreatorormaybenot): implement updating the controller.
}
