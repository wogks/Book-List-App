import 'package:bookapp/book_list/book_list_view_model.dart';
import 'package:bookapp/login_page/login_screen.dart';
import 'package:bookapp/root_screen/root_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../add_book/add_book_screen.dart';
import '../book_model.dart/book.dart';
import '../book_update/book_update_page.dart';

class BookListScreen extends StatefulWidget {
  BookListScreen({Key? key}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final viewModel = BookListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 리스트 앱'),
        actions: [
          IconButton(
            onPressed: () {
              viewModel.logout();
              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RootScreen()),
                      );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Book>>(
          stream: viewModel.booksStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Book book = document.data()! as Book;
                return  ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      BookListViewModel().deleteBook(document.id);
                    },
                    icon: const Icon(Icons.delete_forever)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateBookScreen(document)),
                      );
                    },
                    title: Text(book.title),
                    subtitle: Text(book.author),
                    leading: Image.network(
                      book.imageUrl,
                      width: 100,
                      height: 100,
                    ),
                  );
                
              }
              ).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
