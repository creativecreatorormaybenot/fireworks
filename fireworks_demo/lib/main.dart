import 'package:fireworks/fireworks.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    title: 'Fireworks',
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

  var _showInfoOverlay = false;

  @override
  void dispose() {
    _controller.dispose();

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
                      Center(
                        child: Text(
                          'Hover with your mouse to launch fireworks to your '
                          'mouse :)\n'
                          'Or just lean back and enjoy the show (:\n\n'
                          'Click again to close this.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
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
