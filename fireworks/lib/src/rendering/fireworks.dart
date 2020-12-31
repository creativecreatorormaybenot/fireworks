import 'package:fireworks/src/foundation/controller.dart';
import 'package:flutter/rendering.dart';

class RenderFireworks extends RenderBox {
  RenderFireworks({
    required this.controller,
  });

  // todo(creativecreatorormaybenot): implement updating the controller.
  final FireworkController controller;

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);

    controller.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    controller.removeListener(markNeedsPaint);

    super.detach();
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

  late TextPainter _yearStrokePainter, _yearPainter;

  @override
  void performLayout() {
    final year = DateTime.now().add(Duration(days: 333)).year.toString();
    final fontSize = constraints.maxWidth / year.length * 5 / 4;

    _yearStrokePainter = TextPainter(
      text: TextSpan(
        text: year,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 1,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = fontSize / 72
            ..color = const Color(0xffffffff),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.biggest.width);
    _yearPainter = TextPainter(
      text: TextSpan(
        text: year,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.biggest.width);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..clipRect(offset & size)
      ..translate(offset.dx, offset.dy);

    _drawBackground(canvas);
    _drawFireworks(canvas);
    _drawYear(canvas);

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
        ..strokeWidth = 2
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
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawYear(Canvas canvas) {
    canvas.saveLayer(
      Offset.zero & size,
      Paint()..blendMode = BlendMode.difference,
    );
    _yearStrokePainter.paint(
      canvas,
      Offset(
        (size.width - _yearStrokePainter.width) / 2,
        (size.height - _yearStrokePainter.height) / 2,
      ),
    );
    canvas.restore();

    canvas.saveLayer(
      Offset.zero & size,
      Paint()..blendMode = BlendMode.colorDodge,
    );
    _yearPainter.paint(
      canvas,
      Offset(
        (size.width - _yearStrokePainter.width) / 2,
        (size.height - _yearStrokePainter.height) / 2,
      ),
    );
    canvas.restore();
  }
}
