import 'package:fireworks/fireworks.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FireworksApp());
}

class FireworksApp extends StatefulWidget {
  const FireworksApp({
    Key? key,
    this.tickerProvider,
  }) : super(key: key);

  final TickerProvider? tickerProvider;

  @override
  _FireworksAppState createState() => _FireworksAppState();
}

class _FireworksAppState extends State<FireworksApp>
    with SingleTickerProviderStateMixin {
  late final _controller =
      FireworkController(vsync: widget.tickerProvider ?? this)
        ..start()
        ..autoLaunchDuration = Duration(milliseconds: 99);

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Fireworks(
          controller: _controller,
        ),
      ),
    );
  }
}
