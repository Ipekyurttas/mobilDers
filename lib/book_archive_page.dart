import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'book.dart';

class BookArchivePage extends StatefulWidget {
  const BookArchivePage({super.key});

  @override
  _BookArchivePageState createState() => _BookArchivePageState();
}

class _BookArchivePageState extends State<BookArchivePage> {
  late Box<Book> bookBox;

  @override
  void initState() {
    super.initState();
    bookBox = Hive.box<Book>('books');
  }

  void _addBook(Book book) {
    bookBox.add(book);
  }

  void _updateBook(int index, Book book) {
    bookBox.putAt(index, book);
  }

  void _deleteBook(int index) {
    bookBox.deleteAt(index);
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF001F3F), // Lacivert
          title: const Text(
            'Yeni Kitap Ekle',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Yazar',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                final book = Book(
                  id: DateTime.now().toString(),
                  title: titleController.text,
                  author: authorController.text,
                  description: descriptionController.text,
                );
                _addBook(book);
                Navigator.of(context).pop();
              },
              child: const Text('Ekle', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showEditBookDialog(int index) {
    final book = bookBox.getAt(index)!;
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author);
    final descriptionController = TextEditingController(text: book.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF001F3F), // Lacivert
          title: const Text(
            'Kitabı Düzenle',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Yazar',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                final updatedBook = Book(
                  id: book.id,
                  title: titleController.text,
                  author: authorController.text,
                  description: descriptionController.text,
                );
                _updateBook(index, updatedBook);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Güncelle',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.library_books, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Kitap Arşivi'),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF001F3F),
              Color(0xFF1565C0),
            ], // Lacivertten maviye
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: bookBox.listenable(),
          builder: (context, Box<Book> box, _) {
            if (box.values.isEmpty) {
              return const Center(
                child: Text(
                  'Henüz kitap yok.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final book = box.getAt(index)!;
                return Card(
                  color: Colors.white.withValues(alpha: 0.9),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kitap Adı: ${book.title}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001F3F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Yazar: ${book.author}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Açıklama: ${book.description}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF001F3F),
                              ),
                              onPressed: () => _showEditBookDialog(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBook(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green, // Yeşil
        onPressed: _showAddBookDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
