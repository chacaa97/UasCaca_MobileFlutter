import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';
import 'user_manager.dart';
import 'auth_page.dart';
import 'register_page.dart';
import 'film_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiManager apiManager =
      ApiManager(baseUrl: 'http://127.0.0.1:8000/api');

  //provider digunakan untuk mengirimkan data dari main.dart ke sub page, sehingga semua yang berada pada context provider bisa memanggil datanya.
  //Pada case ini data baseUrl disebar ke page lain
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserManager()),
        Provider.value(value: apiManager),
      ],
      child: MaterialApp(
        title: 'Flutter Auth CRUD Example',
        initialRoute: '/',
        routes: {
          '/': (context) => AuthPage(),
          '/register': (context) => RegisterPage(),
          '/userList': (context) => Dashboard(),
        },
      ),
    );
  }
}
