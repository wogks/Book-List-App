import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'book_update_view_model.dart';

class UpdateBookScreen extends StatefulWidget {
  const UpdateBookScreen(this.document, {Key? key}) : super(key: key);
  final DocumentSnapshot document;
  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _bytes;
  final viewModel = UpdateBookViewModel();

  @override
  void initState() {
    super.initState();
  }

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
        title: const Text('도서 수정'),
      ),
      body: Column(
        children: [
          GestureDetector(
                onTap: () async {
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    // byte array
                    _bytes = await image.readAsBytes();

                    setState(() {});
                  }
                },
                child: _bytes == null
                    ? Image.network('${widget.document['imageUrl']}',
                        width: 200, height: 200)
                    : Image.memory(_bytes!, width: 200, height: 200),
              ),
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: _titleTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '제목',
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: _authorTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '저자',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            // 에러가 날 것 같은 코드
            viewModel.updateBook(
              document: widget.document,
              title: _titleTextController.text,
              author: _authorTextController.text,
              bytes: _bytes,
            )
            .then((_) => Navigator.pop(context))
            .catchError((e){
              final snackBar = SnackBar(
                          content: Text(e.toString()),
                        );
                        
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
            

          child: const Text('도서 수정');
          } catch (e) {
            // 에러가 났을 때
            final snackBar = SnackBar(
              content: Text(e.toString()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } finally {
            // (옵션)
            // 에러가 나거나, 안 나거나 무조건 마지막에 수행되는 블럭
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
