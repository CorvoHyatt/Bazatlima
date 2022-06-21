import 'package:bazatlima/comprador/producto_list.dart';
import 'package:bazatlima/loginPage.dart';
import 'package:bazatlima/producto_add_edit.dart';
import 'package:bazatlima/signUpPage.dart';
import 'package:bazatlima/underConstruction.dart';
import 'package:bazatlima/vendedor/producto_list_vendedor.dart';
import 'package:bazatlima/rootApp.dart';
import 'package:bazatlima/vistaProducto.dart';
import 'package:bazatlima/vistaUsuario.dart';
import 'package:flutter/material.dart';
import 'package:bazatlima/splashPage.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bazatlima",
      routes: {
        '/': (context) => SplashPage(),
        '/rootApp': (context) => RootApp(),
        '/login': (context) => LoginPage(),
        '/signUpPage': (context) => SignUpPage(),
        '/view-product': (context) => const VistaProducto(),
        '/view-user': (context) => const VistaUsuario(),
        '/add-product': (context) => const ProdductAddEdit(),
        '/edit-product': (context) => const ProdductAddEdit(),
      },
    );
  }
}
