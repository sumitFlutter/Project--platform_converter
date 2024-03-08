import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:platform_convertor/screen/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/contact_provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  ThemeProvider? providerR;
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    providerR = context.read<ThemeProvider>();
    return IntroductionScreen(
      key: _introKey,
      pages: [
        PageViewModel(
          useScrollView: false,
          title: "Demo of ContactViewScreen",
          bodyWidget: Column(
            children: [
              Image.asset(providerR!.introImage,height: MediaQuery.sizeOf(context).height*0.7,width: MediaQuery.sizeOf(context).width,fit: BoxFit.fill,),
            ],
          ),

        ),
      ],
      showSkipButton: true,
      showNextButton: false,
      skip: const Text("Skip",style: TextStyle(color: Colors.grey),),
      onSkip: () {
        Navigator.pushReplacementNamed(context, "dash");
      },
      done: const Text("Done"),
      onDone: () {
        providerR!.introToggle();
        Navigator.pushReplacementNamed(context, "dash");
      },
    );
  }
}
