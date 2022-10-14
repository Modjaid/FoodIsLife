import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/productData.dart';
import '../../../Services/database_service.dart';
import '../../../main.dart';
import 'image_section.dart';
import 'image_section.dart';

class ProductEditorPage extends StatefulWidget {
  ProductData data;

  ProductEditorPage(this.data);
  @override
  _ProductEditorPageState createState() => _ProductEditorPageState();
}

class _ProductEditorPageState extends State<ProductEditorPage> {
  TextEditingController _articleContr = TextEditingController();
  TextEditingController _nameContr = TextEditingController();
  TextEditingController _costContr = TextEditingController();
  TextEditingController _oldCostContr = TextEditingController();
  TextEditingController _descrController = TextEditingController();
  TextEditingController _restContr = TextEditingController();
  DatabaseService db = DatabaseService();
  bool _isNewProduct = true;
  // List<File> newImages = [];
  Widget okIcon = Icon(
    Icons.check_box_outline_blank_outlined,
    size: 40,
    color: Colors.grey,
  );
  @override
  void initState() {
    if (widget.data != null) {
      _isNewProduct = false;
      _articleContr.text = widget.data.article;
      _nameContr.text = widget.data.name;
      _costContr.text = widget.data.cost.toString();
      _oldCostContr.text = widget.data.oldCost.toString();
      _descrController.text = widget.data.description;
      _restContr.text = widget.data.rest.toString();
    } else {
      _isNewProduct = true;
      widget.data = ProductData();
      //TODO: Взять все продукты с базы и обновить их итераторы
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: adminAppBar('<admin>', context), body: _form());
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _input(
                Icon(Icons.arrow_forward_ios), 'Артикль', _articleContr, false),
            _input(Icon(Icons.arrow_forward_ios), 'Имя', _nameContr, false),
            _input(
                Icon(Icons.arrow_forward_ios), 'Новая цена', _costContr, false),
            _input(Icon(Icons.arrow_forward_ios), 'Старая цена', _oldCostContr,
                false),
            _input(Icon(Icons.arrow_forward_ios), 'Описание', _descrController,
                false),
            _input(Icon(Icons.arrow_forward_ios), 'Осталось деталей',
                _restContr, false),
            (!_isNewProduct)
                ? ImageLoader(widget.data)
                : Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'После создания продукта можно добавлять картинки',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
            ButtonBar(
              children: [
                (_isNewProduct)
                    ? SizedBox()
                    : IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        iconSize: 40,
                        onPressed: () async {
                          await db.deleteProductData(widget.data);

                          _isNewProduct = true;
                          setState(() {});
                        }),
                IconButton(
                    icon: (_isNewProduct)
                        ? Icon(Icons.cloud_upload_rounded)
                        : Icon(Icons.refresh_outlined),
                    color: Colors.green,
                    iconSize: 40,
                    onPressed: () {
                      _uploadDB();
                    }),
                okIcon,
              ],
            )
          ],
        ),
      ),
    );
  }

  _input(
      Icon icon, String hint, TextEditingController controller, bool obscure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blueGrey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[900], width: 3)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 1)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: IconTheme(
              data: IconThemeData(color: Colors.black),
              child: icon,
            ),
          ),
        ),
        cursorColor: Colors.black,
      ),
    );
  }

  _uploadDB() async {
    okIcon = Icon(
      Icons.check_box_outline_blank_outlined,
      size: 40,
      color: Colors.grey,
    );
    setState(() {});

    widget.data.article = _articleContr.text;
    widget.data.name = _nameContr.text;
    widget.data.cost = int.tryParse(_costContr.text);
    widget.data.oldCost = int.tryParse(_oldCostContr.text);
    widget.data.description = _descrController.text;
    widget.data.rest = int.tryParse(_restContr.text);
    await db.addOrUpdateProductData(widget.data);
    setState(() {
      okIcon = Icon(Icons.check_circle_rounded, color: Colors.green, size: 40);
      _isNewProduct = false;
    });
  }
}
