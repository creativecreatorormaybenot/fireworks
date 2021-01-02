import 'package:fireworks/src/foundation/controller.dart';
import 'package:fireworks/src/rendering/fireworks.dart';
import 'package:flutter/widgets.dart';

class Fireworks extends LeafRenderObjectWidget {
  Fireworks({
    Key? key,
    required this.controller,
    this.showYear = true,
  }) : super(key: key);

  /// The controller that manages the fireworks and tells the render box what
  /// and when to paint.
  final FireworkController controller;

  /// Whether to paint the year text in the foreground.
  ///
  /// When `false`, the year text is completely omitted.
  final bool showYear;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFireworks(
      controller: controller,
      showYear: showYear,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderFireworks renderObject) {
    renderObject
      ..controller = controller
      ..showYear = showYear;
  }
}
