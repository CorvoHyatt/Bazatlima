import 'dart:convert';
import 'dart:io';

import 'package:bazatlima/Models/categoria_model.dart';
import 'package:bazatlima/Models/producto_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  ButtonState state = ButtonState.init;
  List<dynamic> categorias = List<dynamic>.empty(growable: true);
  bool isAPICallProcess = false;
  ProductoModel? productoModel;
  bool isEditMode = false;
  bool isImageSelected = false;

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

  @override
  Widget build(BuildContext context) {
    final isLoading = state == ButtonState.init;
    final isDone = state == ButtonState.done;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: const Text("Agregar Producto",
              style: TextStyle(color: Colors.amber)),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Form(key: globalKey, child: loadCategorias()),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 0),
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

  Widget loadCategorias() {
    return FutureBuilder(
      future: APIService.getCategorias(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<CategoriaModel>?> model,
      ) {
        if (model.hasData) {
          return productForm();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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
                  initialValue: productoModel!.nombreProducto ?? "",
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
                      ? ""
                      : productoModel!.precio.toString(),
                  borderColor: Colors.black,
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
                  initialValue: productoModel!.descripcion ?? "",
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
          //  Padding(
          //     padding: EdgeInsets.only(bottom: 10, top: 10),
          //     child: FormHelper.submitButton("buttonText", onTap)
          //   ),
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
                "Agregar Producto",
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
            APIService.saveProducto(productoModel!, isEditMode, isImageSelected)
                .then((response) {
              if (response) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
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
