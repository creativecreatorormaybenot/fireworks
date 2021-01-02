# fireworks 

Interactive app(s) for showing fireworks using [Flutter]'s canvas.

## Live demo

You can view a [live demo] of the `fireworks` package in action that allows you to both watch the
fireworks and launch your own firework rockets by hovering with the mouse :)

[![](https://i.ibb.co/G240Lth/Screen-Shot-2021-01-01-at-3-10-00-AM.png)][live demo]

You can [checkout the tweet]((https://twitter.com/creativemaybeno/status/1344848563264770048?s=20))
I made about it. 

## Counter app

## Repo structure

To allow for both the [live demo] and counter app using the same code for rendering the actual
fireworks, the repo contains the following packages:

* [`fireworks`][fireworks], which is a basic Flutter **package** that contains a
  [render object and widget](https://youtu.be/HqXNGawzSbY) for rendering the fireworks. It also
  contains a controller class that manages the rockets, explosion particles, vsync, etc.
* [`fireworks_demo`][fireworks_demo], which is the app that is used for the [live demo].
* [`fireworks_counter`][fireworks_counter], which is a slightly modified version of the Flutter
  template app using the `fireworks` package. 

[Flutter]: https://github.com/flutter/flutter
[live demo]: https://fireworks.creativemaybeno.dev
[fireworks]: https://github.com/creativecreatorormaybenot/fireworks/tree/main/fireworks
[fireworks_demo]: https://github.com/creativecreatorormaybenot/fireworks/tree/main/fireworks_demo
[fireworks_counter]: https://github.com/creativecreatorormaybenot/fireworks/tree/main/fireworks_counter
