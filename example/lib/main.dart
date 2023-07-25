import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide GridPaper;

import 'package:millimeters/millimeters.dart';
import 'package:millimeters_example/dimensions.dart';
import 'package:millimeters_example/transparent_window.dart'
    if (dart.library.html) 'package:millimeters_example/transparent_window_fallback.dart';

import 'grid.dart';

Future<void> main() async {
  await makeWindowTransparent();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Millimeters.fromView(
      child: MaterialApp(
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 61, 200, 89),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 59, 158, 73),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Demo(
            blockSize: Size(50, 50),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

class Demo extends StatelessWidget {
  const Demo({
    super.key,
    this.blockSize = const Size(50, 50),
  });

  final Size blockSize;

  @override
  Widget build(BuildContext context) {
    final physicalities = Millimeters.of(context);
    final mm = physicalities.mm;
    final blockSize = this.blockSize.apply(mm);
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Monitor size: $physicalities"),
              ),
            ),
          ),
          Positioned.fill(
            child: GridPaper(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.66),
              interval: mm(50),
              divisions: 5,
              subdivisions: 10,
            ),
          ),
          const DimensionsIndicator(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(mm(23.25)),
                  child: switch ((
                    kDebugMode,
                    Image.asset(
                      "assets/euro.webp",
                      width: mm(23.25),
                      height: mm(23.25),
                      semanticLabel: "1 Euro coin",
                    )
                  )) {
                    (true, Widget coin) => Banner(
                        message: "DEBUG",
                        location: BannerLocation.topEnd,
                        child: coin,
                      ),
                    (false, Widget coin) => coin,
                  }),
            ),
          ),
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.move,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: constraints.isSatisfiedBy(blockSize)
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                  color: constraints.isSatisfiedBy(blockSize)
                      ? Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.33)
                      : Theme.of(context)
                          .colorScheme
                          .errorContainer
                          .withOpacity(0.33),
                ),
                child: SizedBox.fromSize(
                  size: blockSize,
                  child: const DimensionsIndicator(),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
