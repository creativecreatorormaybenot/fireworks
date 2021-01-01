import 'package:fireworks/fireworks.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: _Fireworks(),
    ),
  ));
}

class _Fireworks extends StatefulWidget {
  const _Fireworks({Key? key}) : super(key: key);

  @override
  _FireworksState createState() => _FireworksState();
}

class _FireworksState extends State<_Fireworks>
    with SingleTickerProviderStateMixin {
  late final _controller = FireworkController(vsync: this)
    ..start()
    ..autoLaunchDuration = Duration(milliseconds: 142)
    ..explosionParticleCount = 242;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Fireworks(
      controller: _controller,
    );
  }
}
