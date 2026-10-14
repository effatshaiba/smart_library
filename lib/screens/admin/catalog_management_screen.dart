import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../models/category.dart';
import '../../models/author.dart';
import '../../models/publisher.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/book_card.dart';
import '../../widgets/custom_text_field.dart';

class CatalogManagementScreen extends StatelessWidget {
  const CatalogManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const AccessibilityToolbar(
          title: 'Catalog & Inventory',
        ),
        body: Column(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(icon: Icon(Icons.book), text: 'Books'),
                  Tab(icon: Icon(Icons.category), text: 'Categories'),
                  Tab(icon: Icon(Icons.person), text: 'Authors'),
                  Tab(icon: Icon(Icons.business), text: 'Publishers'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _BooksTab(),
                  _CategoriesTab(),
                  _AuthorsTab(),
                  _PublishersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. Books Tab
class _BooksTab extends StatelessWidget {
  const _BooksTab();

  void _showAddBookDialog(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context, listen: false);
    final titleCtrl = TextEditingController();
    final isbnCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final copiesCtrl = TextEditingController(text: '3');

    String selectedCategoryId = data.categories.isNotEmpty ? data.categories.first.id : '';
    String selectedAuthorId = data.authors.isNotEmpty ? data.authors.first.id : '';
    String selectedPublisherId = data.publishers.isNotEmpty ? data.publishers.first.id : '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Book'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(controller: titleCtrl, label: 'Book Title', prefixIcon: Icons.book),
                const SizedBox(height: 12),
                CustomTextField(controller: isbnCtrl, label: 'ISBN Number', prefixIcon: Icons.qr_code),
                const SizedBox(height: 12),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                  items: data.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategoryId = val!),
                ),
                const SizedBox(height: 12),

                // Author Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedAuthorId,
                  decoration: const InputDecoration(labelText: 'Author', prefixIcon: Icon(Icons.person)),
                  items: data.authors.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedAuthorId = val!),
                ),
                const SizedBox(height: 12),

                // Publisher Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedPublisherId,
                  decoration: const InputDecoration(labelText: 'Publisher', prefixIcon: Icon(Icons.business)),
                  items: data.publishers.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedPublisherId = val!),
                ),
                const SizedBox(height: 12),

                CustomTextField(controller: descCtrl, label: 'Description', prefixIcon: Icons.description, maxLines: 2),
                const SizedBox(height: 12),
                CustomTextField(controller: copiesCtrl, label: 'Total Copies', prefixIcon: Icons.numbers, keyboardType: TextInputType.number),
                const SizedBox(height: 12),

                // Image Upload Support Simulation (FR11)
                OutlinedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Simulate WebP / Image Upload'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book cover image selected successfully (Firebase Storage ready).')),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  final cat = data.categories.firstWhere((c) => c.id == selectedCategoryId);
                  final auth = data.authors.firstWhere((a) => a.id == selectedAuthorId);
                  final pub = data.publishers.firstWhere((p) => p.id == selectedPublisherId);
                  final copies = int.tryParse(copiesCtrl.text) ?? 1;

                  data.addBook(
                    Book(
                      id: 'book_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleCtrl.text,
                      isbn: isbnCtrl.text,
                      categoryId: cat.id,
                      categoryName: cat.name,
                      authorId: auth.id,
                      authorName: auth.name,
                      publisherId: pub.id,
                      publisherName: pub.name,
                      description: descCtrl.text,
                      totalCopies: copies,
                      availableCopies: copies,
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
        onPressed: () => _showAddBookDialog(context),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: data.books.length,
        itemBuilder: (context, index) {
          final book = data.books[index];
          return BookCard(
            book: book,
            onTap: () {},
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => data.deleteBook(book.id),
            ),
          );
        },
      ),
    );
  }
}

// 2. Categories Tab
class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();

  void _showAddCategoryDialog(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: nameCtrl, label: 'Category Name', prefixIcon: Icons.category),
            const SizedBox(height: 12),
            CustomTextField(controller: descCtrl, label: 'Description', prefixIcon: Icons.description),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                data.addCategory(Category(
                  id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text,
                  description: descCtrl.text,
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
        onPressed: () => _showAddCategoryDialog(context),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.categories.length,
        itemBuilder: (context, index) {
          final cat = data.categories[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.category)),
              title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(cat.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => data.deleteCategory(cat.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 3. Authors Tab
class _AuthorsTab extends StatelessWidget {
  const _AuthorsTab();

  void _showAddAuthorDialog(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final bioCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Author'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: nameCtrl, label: 'Author Name', prefixIcon: Icons.person),
            const SizedBox(height: 12),
            CustomTextField(controller: bioCtrl, label: 'Biography', prefixIcon: Icons.info_outline),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                data.addAuthor(Author(
                  id: 'auth_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text,
                  bio: bioCtrl.text,
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Author'),
        onPressed: () => _showAddAuthorDialog(context),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.authors.length,
        itemBuilder: (context, index) {
          final auth = data.authors[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(auth.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(auth.bio),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => data.deleteAuthor(auth.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 4. Publishers Tab
class _PublishersTab extends StatelessWidget {
  const _PublishersTab();

  void _showAddPublisherDialog(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final addrCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Publisher'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: nameCtrl, label: 'Publisher Name', prefixIcon: Icons.business),
            const SizedBox(height: 12),
            CustomTextField(controller: addrCtrl, label: 'Address', prefixIcon: Icons.location_on_outlined),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                data.addPublisher(Publisher(
                  id: 'pub_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text,
                  address: addrCtrl.text,
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Publisher'),
        onPressed: () => _showAddPublisherDialog(context),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.publishers.length,
        itemBuilder: (context, index) {
          final pub = data.publishers[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.business)),
              title: Text(pub.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(pub.address),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => data.deletePublisher(pub.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
