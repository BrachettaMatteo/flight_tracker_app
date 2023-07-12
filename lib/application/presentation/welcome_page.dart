import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flight_tracker/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class WelcomePage extends StatelessWidget {
  final PageController _controller = PageController(initialPage: 0);
  WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _getPage(
        urlImage: "asset/img/splash1.svg",
        title: "Flight tracker",
        description: "Track your flights and check the updates",
        finalPage: false,
        context: context,
      ),
      _getPage(
        urlImage: "asset/img/splash2.svg",
        title: "Add flight",
        description:
            "insert iata code for flight and add the flight to homepage",
        finalPage: false,
        context: context,
      ),
      _getPage(
        urlImage: "asset/img/splash3.svg",
        title: "Control",
        description: "keep track of your flights",
        finalPage: true,
        context: context,
      ),
    ];
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _controller,
            children: screens,
          ),
          Positioned(
              top: 30,
              right: 30,
              child: TextButton(
                  onPressed: () => context.router.replace(const HomeRoute()),
                  child: Text("Skip",
                      style: Theme.of(context).textTheme.labelLarge))),
          Positioned(
              bottom: 20,
              child: Center(
                child: SmoothPageIndicator(
                    controller: _controller,
                    count: screens.length,
                    effect: JumpingDotEffect(
                        activeDotColor: Theme.of(context).primaryColor),
                    onDotClicked: (index) => _controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        )),
              ))
        ],
      ),
    ));
  }

  _getPage({
    required String urlImage,
    required String title,
    required String description,
    required bool finalPage,
    required BuildContext context,
  }) =>
      SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  urlImage,
                  height: 300,
                ),
                AutoSizeText(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            )),
            Visibility(
                visible: finalPage,
                child: Positioned(
                  bottom: 100,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(10),
                          shape: MaterialStatePropertyAll(
                              ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).primaryColor)),
                      onPressed: () =>
                          context.router.replace(const HomeRoute()),
                      child: const Text(
                        "start to tracking flight",
                        style: TextStyle(color: Colors.white),
                      )),
                )),
          ],
        ),
      );
}
