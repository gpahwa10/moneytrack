import 'package:flutter/material.dart';
import 'package:moneytrack/google_sheet_api.dart';
import 'home_page.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  GsheetApi().init();
  runApp(const MoneyTrack());
}

class MoneyTrack extends StatelessWidget {
  const MoneyTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}