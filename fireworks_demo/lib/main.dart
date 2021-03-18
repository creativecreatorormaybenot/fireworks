import 'dart:math';

import 'package:fireworks/fireworks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp(
    title: 'Fireworks',
    theme: ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.yellowAccent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: Colors.yellow,
        selectionHandleColor: Colors.yellowAccent,
      ),
    ),
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
  late final _controller = FireworkController(vsync: this)..start();
  late final _titleEditingController = TextEditingController(
    text: _controller.title,
  );
  late final _autoLaunchEditingController = TextEditingController(
    text: _controller.autoLaunchDuration.inMilliseconds.toString(),
  );
  late final _spawnTimeoutEditingController = TextEditingController(
    text: _controller.rocketSpawnTimeout.inMilliseconds.toString(),
  );
  late final _particleCountEditingController = TextEditingController(
    text: _controller.explosionParticleCount.toString(),
  );
  late final _particleSizeEditingController = TextEditingController(
    text: (_controller.particleSize * 10 ~/ 1).toString(),
  );

  var _showInfoOverlay = false;

  @override
  void dispose() {
    _controller.dispose();
    _titleEditingController.dispose();
    _autoLaunchEditingController.dispose();
    _spawnTimeoutEditingController.dispose();
    _particleCountEditingController.dispose();
    _particleSizeEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showInfoOverlay = !_showInfoOverlay;
        });
      },
      child: Stack(
        children: [
          Fireworks(
            controller: _controller,
          ),
          IgnorePointer(
            ignoring: !_showInfoOverlay,
            child: SizedBox.expand(
              child: AnimatedOpacity(
                opacity: _showInfoOverlay ? 1 : 0,
                duration: const Duration(milliseconds: 212),
                child: ColoredBox(
                  color: const Color(0xeeffffff),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Tooltip(
                          message: 'fireworks repo on GitHub',
                          child: MouseRegion(
                            cursor: MaterialStateMouseCursor.clickable,
                            child: GestureDetector(
                              onTap: () {
                                launch(
                                    'https://github.com/creativecreatorormaybenot/fireworks');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Image.asset(
                                  'assets/github.png',
                                  width: 96,
                                  height: 96,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Tooltip(
                          message: '@creativemaybeno on Twitter',
                          child: MouseRegion(
                            cursor: MaterialStateMouseCursor.clickable,
                            child: GestureDetector(
                              onTap: () {
                                launch(
                                    'https://twitter.com/creativemaybeno/status/1344848563264770048?s=20');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Image.asset(
                                  'assets/twitter.png',
                                  width: 96,
                                  height: 96,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 176,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(
                                flex: 3,
                              ),
                              Text(
                                'Hover with your mouse to launch fireworks to '
                                'your mouse :)\n'
                                'Or just lean back and enjoy the show (:\n\n'
                                'Click again to close this.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              _ConfigurationTextField(
                                controller: _titleEditingController,
                                helperText: 'Title text (empty for no title)',
                                onChanged: (value) {
                                  _controller.title = value;
                                },
                              ),
                              _ConfigurationTextField(
                                controller: _autoLaunchEditingController,
                                digitsOnly: true,
                                helperText: 'Auto launch period in ms '
                                    '(empty or 0 to disable auto launching)',
                                onChanged: (value) {
                                  _controller.autoLaunchDuration = value.isEmpty
                                      ? Duration.zero
                                      : Duration(
                                          milliseconds: int.parse(value),
                                        );
                                },
                              ),
                              _ConfigurationTextField(
                                controller: _spawnTimeoutEditingController,
                                digitsOnly: true,
                                helperText: 'Mouse spawn period in ms '
                                    '(empty or 0 to disable mouse launching)',
                                onChanged: (value) {
                                  _controller.rocketSpawnTimeout = value.isEmpty
                                      ? Duration.zero
                                      : Duration(
                                          milliseconds: int.parse(value),
                                        );
                                },
                              ),
                              _ConfigurationTextField(
                                controller: _particleCountEditingController,
                                digitsOnly: true,
                                helperText: 'Particle count',
                                onChanged: (value) {
                                  _controller.explosionParticleCount =
                                      value.isEmpty
                                          ? 0
                                          : max(0, int.parse(value));
                                },
                              ),
                              _ConfigurationTextField(
                                controller: _particleSizeEditingController,
                                digitsOnly: true,
                                helperText: 'Particle size over ten in px',
                                onChanged: (value) {
                                  _controller.particleSize =
                                      value.isEmpty ? 0 : int.parse(value) / 10;
                                },
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stylized text field widget for configuring the demo in the overlay.
class _ConfigurationTextField extends StatelessWidget {
  /// Constructs a [_ConfigurationTextField] widget.
  const _ConfigurationTextField({
    Key? key,
    required this.controller,
    this.helperText,
    this.onChanged,
    this.digitsOnly = false,
  }) : super(key: key);

  /// The text editing controller.
  final TextEditingController controller;

  /// Called when the value in the text field changes.
  final ValueChanged<String>? onChanged;

  /// Helper text that is displayed below the text field explaining how to
  /// use the field for configuration.
  final String? helperText;

  /// Whether only digits should be allowed in the input.
  final bool digitsOnly;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 364,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: digitsOnly ? TextInputType.number : TextInputType.text,
        inputFormatters: [
          if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          helperText: helperText,
        ),
      ),
    );
  }
}
