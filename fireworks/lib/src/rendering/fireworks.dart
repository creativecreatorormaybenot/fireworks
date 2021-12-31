import 'dart:math';

import 'package:fireworks/src/foundation/controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class RenderFireworks extends RenderBox {
  RenderFireworks({
    required FireworkController controller,
  })  : _controller = controller,
        _previousTitle = controller.title;

  /// The controller that manages the fireworks and tells the render box what
  /// and when to paint.
  FireworkController get controller => _controller;
  FireworkController _controller;

  set controller(FireworkController value) {
    if (controller == value) return;

    // Detach old controller.
    _controller.removeListener(_handleControllerUpdate);
    _controller = value;

    // Attach new controller.
    controller.addListener(_handleControllerUpdate);
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);

    controller.addListener(_handleControllerUpdate);
  }

  @override
  void detach() {
    controller.removeListener(_handleControllerUpdate);

    super.detach();
  }

  String _previousTitle;

  void _handleControllerUpdate() {
    if (_previousTitle != controller.title) {
      _previousTitle = controller.title;
      // We need to relayout because the text painters need to change.
      markNeedsLayout();
    }
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    controller.windowSize = size;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  late TextPainter _titleStrokePainter, _titlePainter;

  @override
  void performLayout() {
    final fontSize = constraints.maxWidth / controller.title.length * 5 / 4;

    _titleStrokePainter = TextPainter(
      text: TextSpan(
        text: controller.title,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 1,
          color: null,
          foreground: Paint()
            // On web, the stroke does not seem to work properly.
            ..style = kIsWeb ? PaintingStyle.fill : PaintingStyle.stroke
            ..strokeWidth = 9
            ..strokeCap = StrokeCap.round
            ..color = const Color(0xffffffff),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.biggest.width);
    _titlePainter = TextPainter(
      text: TextSpan(
        text: controller.title,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.biggest.width);
  }

  @override
  bool hitTestSelf(Offset position) {
    return size.contains(position);
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerHoverEvent) {
      controller.spawnRocket(Point(
        event.localPosition.dx,
        event.localPosition.dy,
      ));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..clipRect(offset & size)
      ..translate(offset.dx, offset.dy);

    _drawBackground(canvas);
    _drawFireworks(canvas);
    _drawTitle(canvas);
    _drawStars(canvas);

    canvas.restore();
  }

  void _drawBackground(Canvas canvas) {
    canvas.drawPaint(Paint()..color = const Color(0xff000000));
  }

  void _drawFireworks(Canvas canvas) {
    for (final rocket in controller.rockets) {
      final paint = Paint()
        ..color =
            HSVColor.fromAHSV(1, rocket.hue, 1, rocket.brightness).toColor()
        ..strokeWidth = rocket.size
        ..style = PaintingStyle.stroke;

      canvas.drawPath(
        Path()
          ..moveTo(
            rocket.trailPoints.last.x,
            rocket.trailPoints.last.y,
          )
          ..lineTo(
            rocket.position.x,
            rocket.position.y,
          ),
        paint,
      );
    }

    for (final particle in controller.particles) {
      canvas.drawPath(
        Path()
          ..moveTo(
            particle.trailPoints.last.x,
            particle.trailPoints.last.y,
          )
          ..lineTo(
            particle.position.x,
            particle.position.y,
          ),
        Paint()
          ..color = HSVColor.fromAHSV(
                  particle.alpha, particle.hue % 360, 1, particle.brightness)
              .toColor()
          ..blendMode = BlendMode.screen
          ..strokeWidth = particle.size
          ..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawTitle(Canvas canvas) {
    if (_controller.title.isEmpty) return;

    canvas.saveLayer(
      Offset.zero & size,
      Paint()..blendMode = BlendMode.difference,
    );
    _titleStrokePainter.paint(
      canvas,
      Offset(
        (size.width - _titleStrokePainter.width) / 2,
        (size.height - _titleStrokePainter.height) / 2,
      ),
    );
    canvas.restore();

    canvas.saveLayer(
      Offset.zero & size,
      Paint()..blendMode = BlendMode.colorDodge,
    );
    _titlePainter.paint(
      canvas,
      Offset(
        (size.width - _titleStrokePainter.width) / 2,
        (size.height - _titleStrokePainter.height) / 2,
      ),
    );
    canvas.restore();
  }

  void _drawStars(Canvas canvas) {
    final random = Random(42);
    for (var i = 0; i < 199; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        size.shortestSide / 4e2 * pow(random.nextDouble().clamp(1 / 5, 1), 2),
        Paint()..color = Color(0xffffffff),
      );
    }
  }
}
