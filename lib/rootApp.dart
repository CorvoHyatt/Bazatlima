// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, file_names, avoid_print

import 'package:bazatlima/Models/usuario_model.dart';
import 'package:bazatlima/comprador/producto_list.dart';
import 'package:bazatlima/underConstruction.dart';
import 'package:bazatlima/vendedor/producto_list_vendedor.dart';
import 'package:flutter/material.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  RootAppState createState() => RootAppState();
}

class RootAppState extends State<RootApp> {
  int activeTab = 0;
  int _currentIndex = 0;
  UsuarioModel? usuario;
  late dynamic tabs;

  @override
  void initState() {
    super.initState();
    usuario = UsuarioModel();
    tabs = [
      ProductList(),
      UnderConstruction(),
      ProductListVendedor(),
      UnderConstruction(),
      UnderConstruction(),
      UnderConstruction(
        usuario: usuario,
      ),
    ];
    cargarUsuario();
  }

  void cargarUsuario() async {
    Future.delayed(Duration.zero, (() {
      print(ModalRoute.of(context)?.settings.arguments);
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = (ModalRoute.of(context)?.settings.arguments)
            as Map<String, dynamic>;
        usuario = arguments["usuario"];
        setState(() {});
      }
    }));
  }

  // Widget userInfo() {
  //   return FutureBuilder(
  //     future: Future.delayed(Duration.zero, (() {
  //       print(ModalRoute.of(context)?.settings.arguments);
  //       if (ModalRoute.of(context)?.settings.arguments != null) {
  //         final Map arguments = (ModalRoute.of(context)?.settings.arguments)
  //             as Map<String, dynamic>;
  //         usuario = arguments["usuario"];
  //         setState(() {});
  //       }
  //     })),
  //     builder: (
  //       BuildContext context,
  //       AsyncSnapshot<UsuarioModel?> usuario,
  //     ) {
  //       print("Carga de usuario${usuario.data}");
  //       if (usuario.hasData) {
  //         return cosa();
  //       }
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print(usuario!.correo);
    return Scaffold(
      backgroundColor: (Color.fromARGB(255, 255, 255, 255)),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.white70),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.storefront_rounded),
              label: "Purchase",
              backgroundColor: Color.fromARGB(255, 0, 0, 0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_sharp),
              label: "To Sell",
              backgroundColor: Color.fromARGB(255, 0, 0, 0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Categories",
              backgroundColor: Color.fromARGB(255, 0, 0, 0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: "Chat",
              backgroundColor: Color.fromARGB(255, 0, 0, 0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Me",
              backgroundColor: Color.fromARGB(255, 0, 0, 0)),
        ],
      ),
      body: tabs[_currentIndex],
    );
  }

  Widget cosa() {
    return Scaffold();
  }
}
