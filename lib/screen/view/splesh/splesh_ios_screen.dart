import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class IosSpleshScreen extends StatefulWidget {
  const IosSpleshScreen({super.key});

  @override
  State<IosSpleshScreen> createState() => _IosSpleshScreenState();
}

class _IosSpleshScreenState extends State<IosSpleshScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ThemeProvider>().getIntroStatus();
    Future.delayed(const Duration(seconds: 3),() => context.read<ThemeProvider>().introScreen?Navigator.pushReplacementNamed(context, "home"):Navigator.pushReplacementNamed(context, "intro"));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: CupertinoPageScaffold(child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Image.asset("assets/logo/logo.png",height: 120,width: 120,fit: BoxFit.cover,)),
        const SizedBox(height: 5,),
        const Center(child: Text("Contact Info",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),)
      ],
    ),));
  }
}
