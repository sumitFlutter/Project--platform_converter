import 'package:flutter/material.dart';
import 'package:platform_convertor/screen/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/ui_provider.dart';

class SpleshScreen_ extends StatefulWidget {
  const SpleshScreen_({super.key});

  @override
  State<SpleshScreen_> createState() => _SpleshState();
}

class _SpleshState extends State<SpleshScreen_> {
  @override
  void initState() {
    super.initState();
    context.read<ThemeProvider>().getIntroStatus();
    Future.delayed(const Duration(seconds: 3),() => Navigator.pushReplacementNamed(context, context.read<ThemeProvider>().introScreen?context.read<UiProvider>().pAppUi==false?"dash":"home":"intro"),);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/logo/logo.png",height: 120,width: 120,fit: BoxFit.cover,)),
          const SizedBox(height: 5,),
          const Center(child: Text("Contact Info",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),)
        ],
      ),
    ),);
  }
}