import 'package:bookapp/add_book/add_book_screen.dart';
import 'package:bookapp/book_list/book_list_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../book_update/book_update_page.dart';

class BooklistScreen extends StatelessWidget {
  BooklistScreen({Key? key}) : super(key: key);
  final viewModel = BookListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 리스트 앱'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: viewModel.booksStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateBookScreen(document)));
                }),
                trailing: IconButton(
                    onPressed: () {
                      BookListViewModel().deleteBook(document: document);
                    },
                    icon: Icon(Icons.delete_forever)),
                title: Text(document['title']),
                subtitle: Text(document['author']),
                leading: Image.network(data['imageUrl'])
                );
          }).toList());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBookScreen()));
        },
      ),
    );
  }
}
