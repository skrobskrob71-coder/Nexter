import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/splash/splash_screen.dart';

void main(){WidgetsFlutterBinding.ensureInitialized();runApp(const NaxterApp());}
class NaxterApp extends StatelessWidget{const NaxterApp({super.key});@override Widget build(BuildContext c)=>MaterialApp(title:'ناكستر Naxter',debugShowCheckedModeBanner:false,locale:const Locale('ar'),supportedLocales:const[Locale('ar'),Locale('en')],localizationsDelegates:GlobalMaterialLocalizations.delegates,theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF0D47A1),brightness:Brightness.light),scaffoldBackgroundColor:const Color(0xFFF5F5F5),fontFamily:'Cairo',appBarTheme:const AppBarTheme(backgroundColor:Color(0xFF0D47A1),foregroundColor:Colors.white)),home:const Directionality(textDirection:TextDirection.rtl,child:SplashScreen()));}
