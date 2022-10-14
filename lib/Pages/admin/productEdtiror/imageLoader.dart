import 'dart:html';
import 'dart:typed_data';

import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../../Model/productData.dart';
import '../../../Services/database_service.dart';

class ImageLoader extends StatefulWidget {
  ProductData product;
  ImageLoader(this.product);
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(children: _drawImages()),
        FloatingActionButton(
          isExtended: true,
          onPressed: _setNewImageWindow,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add_a_photo,
          ),
        ),
      ],
    );
  }

  List<Widget> _drawImages() {
    List<Widget> widgets = [];
    widget.product.images.forEach((element) {
      widgets.add(Container(
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.black,
          width: 1,
        )),
        height: 250,
        width: 250,
        child: Stack(
          children: [
            Image.network(element),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              onPressed: () async {
                await db.destroyImageFromCloud(element);
                widget.product.images.remove(element);
                await db.addOrUpdateProductData(widget.product);
                setState(() {});
              },
            )
          ],
        ),
      ));
    });

    return widgets;
  }

  Future _setNewImageWindow() async {
    List<File> imageFiles =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.file);
    if (imageFiles != null) {
      await db.uploadImageFIles(widget.product, imageFiles);
      setState(() {});
    }
  }
}
