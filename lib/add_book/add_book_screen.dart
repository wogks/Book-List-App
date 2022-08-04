import 'dart:ffi';
import 'dart:typed_data';

import 'package:bookapp/add_book/add_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class AddBookScreen extends StatefulWidget {
  AddBookScreen({Key? key}) : super(key: key);
  final viewModel = AddBookViewModel();
  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final viewModel = AddBookViewModel();
  Uint8List? _bytes;

  @override
  void dispose() {
    _titleTextController.dispose();
    _authorTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('도서 추가'),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: (() async {
                XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  _bytes = await image.readAsBytes();
                  setState(() {});
                }
              }),
              child: _bytes == null
                  ? Container(
                      width: 200,
                      height: 200,
                      color: Colors.amber,
                    )
                  : Image.memory(
                      _bytes!,
                      width: 200,
                      height: 200,
                    ),
            ),
            TextField(
              controller: _titleTextController,
              decoration: InputDecoration(hintText: '제목'),
            ),
            TextField(
              controller: _authorTextController,
              decoration: InputDecoration(hintText: '작가'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            viewModel.addBook(
              title: _titleTextController.text,
              author: _authorTextController.text,
              bytes: _bytes,
            );
            Navigator.pop(context);
          },
          child: Icon(Icons.add),
        ));
  }
}
