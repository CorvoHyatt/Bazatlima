import 'dart:convert';
import 'dart:io';

import 'package:bazatlima/Models/categoria_model.dart';
import 'package:bazatlima/Models/producto_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'api_service.dart';
import 'config.dart';

enum ButtonState { init, loading, done }

class ProdductAddEdit extends StatefulWidget {
  const ProdductAddEdit({Key? key}) : super(key: key);

  @override
  State<ProdductAddEdit> createState() => _ProdductAddEditState();
}

class _ProdductAddEditState extends State<ProdductAddEdit> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  ButtonState state = ButtonState.init;
  List<dynamic> categorias = List<dynamic>.empty(growable: true);
  bool isAPICallProcess = false;
  ProductoModel? productoModel;
  bool isEditMode = false;
  bool isImageSelected = false;
  int? idUsuario;

  @override
  void initState() {
    super.initState();
    //Llenar categorias desde DB
    categorias.add({'idCategoria': "1", 'categoria': "Accesorios"});
    categorias.add({'idCategoria': "2", 'categoria': "Muebles"});
    categorias
        .add({'idCategoria': "3", 'categoria': "Libros, revistas y comics"});
    categorias.add({'idCategoria': "4", 'categoria': "Electrodomésticos"});
    categorias.add({'idCategoria': "5", 'categoria': "Consolas y videojuegos"});
    categorias
        .add({'idCategoria': "6", 'categoria': "Electronica, audio y video"});
    categorias.add({'idCategoria': "7", 'categoria': "Ropa, Moda"});
    categorias.add({'idCategoria': "8", 'categoria': "Papelería"});
    categorias.add({'idCategoria': "9", 'categoria': "Computación"});
    productoModel = ProductoModel();
    _cargarId();
    Future.delayed(Duration.zero, (() {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = (ModalRoute.of(context)?.settings.arguments)
            as Map<String, dynamic>;
        productoModel = arguments["model"];
        isEditMode = true;
        setState(() {
          print(productoModel!.descripcion);
        });
      }
    }));
  }

  _cargarId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUsuario = prefs.getInt("idUsuario") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = state == ButtonState.init;
    final isDone = state == ButtonState.done;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: isEditMode != true
              ? const Text("Agregar Producto",
                  style: TextStyle(color: Colors.amber))
              : const Text("Editar Producto",
                  style: TextStyle(color: Colors.amber)),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Form(key: globalKey, child: productForm()),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: buildButton(isLoading, isDone)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget productForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          picPicker(isImageSelected, productoModel!.imagen ?? "", (file) {
            setState(() {
              productoModel!.imagen = file.path;
              isImageSelected = true;
            });
          }),
          Padding(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: FormHelper.inputFieldWidget(
                  context, "ProductName", "Nombre del producto",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'El nombre de producto no puede estar vacío';
                }
              }, (onSavedVal) {
                productoModel!.nombreProducto = onSavedVal;
              },
                  initialValue:
                      productoModel!.nombreProducto ?? "Producto nuevo",
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.data_saver_off_outlined),
                  prefixIconColor: Colors.black)),
          Padding(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: FormHelper.inputFieldWidget(
                  context, "ProductPrice", "Precio del Producto",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'El Precio de producto no puede estar vacío';
                }
              }, (onSavedVal) {
                productoModel!.precio = int.parse(onSavedVal);
              },
                  initialValue: productoModel!.precio == null
                      ? "4400"
                      : productoModel!.precio.toString(),
                  borderColor: Colors.black,
                  isNumeric: true,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.monetization_on),
                  prefixIconColor: Colors.black)),
          Padding(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: FormHelper.inputFieldWidget(
                  context, "ProductDescription", "Descripción del Producto",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'La descripción de producto no puede estar vacía';
                }
              }, (onSavedVal) {
                productoModel!.descripcion = onSavedVal;
              },
                  isMultiline: true,
                  multilineRows: 3,
                  initialValue: productoModel!.descripcion ??
                      "Producto nuevo de buena calidad",
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.note_alt),
                  prefixIconColor: Colors.black)),
          Padding(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: FormHelper.dropDownWidget(
                  context, "Selecciona una categoria", "", categorias,
                  (onChangedVal) {
                productoModel!.idCategoria = int.parse(onChangedVal!);
              }, (onValidateVal) {
                if (onValidateVal == null) {
                  return 'Por favor selecciona una categoria';
                }

                return null;
              },
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  optionLabel: "categoria",
                  optionValue: "idCategoria")),
        ],
      ),
    );
  }

  static Widget picPicker(
    bool isFileSelected,
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();

    return Container(
      padding: EdgeInsets.only(bottom: 15, top: 20),
      child: Column(
        children: [
          fileName.isNotEmpty
              ? isFileSelected
                  ? Image.file(
                      File(fileName),
                      height: 200,
                      width: 200,
                    )
                  : SizedBox(
                      child: Image.network(
                        fileName,
                        width: 200,
                        height: 200,
                        fit: BoxFit.scaleDown,
                      ),
                    )
              : SizedBox(
                  child: Image.network(
                    "https://uning.es/wp-content/uploads/2016/08/ef3-placeholder-image.jpg",
                    width: 200,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  ),
                ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35.0,
                  width: 35.0,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.image, size: 35),
                    onPressed: () {
                      _imageFile =
                          _picker.pickImage(source: ImageSource.gallery);
                      _imageFile.then((file) async {
                        onFilePicked(file);
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  height: 35.0,
                  width: 35.0,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.camera, size: 35),
                    onPressed: () {
                      _imageFile =
                          _picker.pickImage(source: ImageSource.camera);
                      _imageFile.then((file) async {
                        onFilePicked(file);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(isLoading, isDone) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(100.0, 60.0),
          maximumSize: Size(350, 60),
          shape: StadiumBorder(),
          side: BorderSide(width: 2, color: Colors.black),
        ),
        child: isLoading
            ? Text(
                isEditMode ? "Editar Producto" : "Agregar Producto",
                style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 57, 62, 63),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600),
              )
            : buildChangeButton(isDone),
        onPressed: () async {
          if (validateAndSave()) {
            setState((() => state = ButtonState.loading));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            APIService.saveProducto(
                    idUsuario, productoModel!, isEditMode, isImageSelected)
                .then((response) {
              if (response) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          title: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 50,
                          ),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.amber)),
                                onPressed: () {
                                  prefs.setInt('index', 1);

                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/rootApp'));
                                  Navigator.popAndPushNamed(
                                    context,
                                    '/rootApp',
                                  );
                                },
                                child: Text(
                                  "Ok",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                          content: isEditMode
                              ? Text(
                                  "Producto editado con exito",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Producto agregado con exito",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                          backgroundColor: Colors.white,
                        ));
              } else {
                FormHelper.showSimpleAlertDialog(
                    context, Config.appName, "Error Ocurred", "Ok", () {
                  Navigator.of(context).pop();
                });
              }
            });
          }
        },
      );

  Widget buildChangeButton(bool isDone) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isDone
            ? const [
                Icon(
                  Icons.done_outline_rounded,
                  color: Colors.black,
                  size: 35,
                ),
                SizedBox(width: 20),
                Text(
                  "Producto guardado",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600),
                )
              ]
            : const [
                CircularProgressIndicator(color: Colors.black),
                SizedBox(width: 50),
                Text(
                  "Guardando...",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600),
                )
              ],
      );
}
