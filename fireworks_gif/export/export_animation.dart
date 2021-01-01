import 'package:fireworks_gif/main.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/src/_matchers_io.dart';

void main() async {
  const fps = 50;
  const animationDuration = Duration(seconds: 10);
  const dimensions = Size(960, 540);

  final provider = _CustomProvider();

  testWidgets('export fireworks animation', (tester) async {
    // Using runAsync to enable using HTTP calls (e.g. for loading images).
    await tester.runAsync(() async {
      await tester.binding.setSurfaceSize(dimensions);
      tester.binding.window.physicalSizeTestValue = dimensions;
      tester.binding.window.devicePixelRatioTestValue = 1;

      await tester.pumpWidget(FireworksApp(
        tickerProvider: provider,
      ));
    });

    final microseconds = animationDuration.inMicroseconds,
        goldensNeeded = fps * (microseconds / 1e6) ~/ 1;

    final fileNameWidth = (goldensNeeded - 1).toString().length;

    for (var i = 0; i < goldensNeeded; i++) {
      provider.onTick(
          Duration(microseconds: microseconds / goldensNeeded * i ~/ 1));
      await tester.pump();

      final matcher = MatchesGoldenFile.forStringPath(
          'fireworks/${'$i'.padLeft(fileNameWidth, '0')}'
          '.png',
          null);
      await matcher.matchAsync(find.byType(SizedBox));
    }
  }, timeout: Timeout(const Duration(hours: 1)));
}

class _CustomProvider extends TickerProvider {
  late final void Function(Duration elapsed) onTick;

  @override
  Ticker createTicker(onTick) {
    this.onTick = onTick;
    return _CustomTicker();
  }
}

class _CustomTicker implements Ticker {
  @override
  void absorbTicker(Ticker originalTicker) {
    throw UnimplementedError();
  }

  @override
  String? get debugLabel => throw UnimplementedError();

  @override
  DiagnosticsNode describeForError(String name) {
    throw UnimplementedError();
  }

  @override
  void dispose() {}

  @override
  bool get isActive => throw UnimplementedError();

  @override
  bool get isTicking => throw UnimplementedError();

  @override
  void scheduleTick({bool rescheduling = false}) {}

  @override
  bool get scheduled => throw UnimplementedError();

  @override
  bool get shouldScheduleTick => throw UnimplementedError();

  @override
  TickerFuture start() {
    return TickerFuture.complete();
  }

  @override
  void stop({bool canceled = false}) {
    throw UnimplementedError();
  }

  @override
  void unscheduleTick() {
    throw UnimplementedError();
  }

  @override
  set muted(bool value) => throw UnimplementedError();

  @override
  bool get muted => throw UnimplementedError();

  @override
  String toString({bool debugIncludeStack = false}) =>
      throw UnimplementedError();
}
