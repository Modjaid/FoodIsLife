import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodislife/Pages/admin/productEdtiror/admin_productEditor_body.dart';

import '../../../Model/productData.dart';
import '../../../Services/database_service.dart';
import '../../../Services/database_service.dart';
import '../../../Services/database_service.dart';
import '../../../main.dart';
import '../createPage/admin_create_body.dart';
import '../createPage/admin_create_body.dart';

class AdminTablePage extends StatefulWidget {
  DatabaseService db = DatabaseService();
  @override
  _AdminTablePageState createState() => _AdminTablePageState();
}

class _AdminTablePageState extends State<AdminTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: adminAppBar('<admin>', context),
      body: FutureBuilder<List<ProductData>>(
        future: widget.db.products(),
        builder: (context, productsData) {
          if (productsData.hasData) {
            return Stack(
              // height: 1200,
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                        child: _drawTable(productsData.data))),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.add,
                          size: 50,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductEditorPage(null)),
                          );
                        },
                      )),
                ),
              ],
            );
          } else if (productsData.hasError) {
            return Text('Its Error! ' + productsData.error.toString());
          } else {
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 5,
            ));
          }
        },
      ),
    );
  }

  Widget _drawTable(List<ProductData> productsData) {
    List<DataRow> rows = [];

    productsData.forEach((element) {
      rows.add(DataRow(cells: [
        DataCell(_cell(element.iterator.toString())),
        DataCell(_cell(element.article)),
        DataCell(_cell(element.name)),
        DataCell(_cell(element.cost.toString())),
        DataCell(_cell(element.oldCost.toString())),
        DataCell(_cell(element.images.length.toString())),
        DataCell(_cell(element.description)),
        DataCell(_cell(element.rest.toString())),
        DataCell(ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            IconButton(
                iconSize: 20,
                color: Colors.red,
                icon: Icon(Icons.delete_rounded),
                onPressed: () async {
                  await widget.db.deleteProductData(element);
                  productsData.remove(element);
                  setState(() {});
                }),
            IconButton(
                iconSize: 20,
                color: Colors.green,
                icon: Icon(Icons.build_circle),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductEditorPage(element)),
                  );
                }),
          ],
        ))
      ]));
    });

    return DataTable(
      showBottomBorder: true,
      columns: [
        DataColumn(label: _cell('id')),
        DataColumn(label: _cell('Артикль')),
        DataColumn(label: _cell('Название')),
        DataColumn(label: _cell("цена")),
        DataColumn(label: _cell("старая цена")),
        DataColumn(label: _cell("картинок")),
        DataColumn(label: _cell("описание")),
        DataColumn(label: _cell("на складе")),
        DataColumn(label: _cell("")),
      ],
      rows: rows,
    );
  }

  Text _cell(String text, {double size = 25}) {
    if (text.length > 15) {
      text = text.substring(0, 15) + '...';
    }
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: size),
    );
  }
}
