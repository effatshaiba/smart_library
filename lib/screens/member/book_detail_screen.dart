import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class BookDetailScreen extends StatelessWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    final book = data.books.firstWhere(
      (b) => b.id == bookId,
      orElse: () => throw Exception('Book not found'),
    );

    final member = auth.currentUser;

    return Scaffold(
      appBar: AccessibilityToolbar(title: book.title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Placeholder Banner
            Center(
              child: Container(
                width: 140,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.book,
                    size: 72,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Book Header Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    book.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                book.isAvailable ? StatusChip.available() : StatusChip.outOfStock(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'By ${book.authorName}',
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // Key Attributes Table
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _DetailRow(icon: Icons.category, label: 'Category', value: book.categoryName),
                    const Divider(),
                    _DetailRow(icon: Icons.business, label: 'Publisher', value: book.publisherName),
                    const Divider(),
                    _DetailRow(icon: Icons.qr_code, label: 'ISBN', value: book.isbn),
                    const Divider(),
                    _DetailRow(
                      icon: Icons.inventory_2,
                      label: 'Available / Total Copies',
                      value: '${book.availableCopies} of ${book.totalCopies} copies available',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              book.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Action Buttons (FR6 & FR9)
            if (auth.isMember && member != null) ...[
              if (book.isAvailable)
                ElevatedButton.icon(
                  icon: const Icon(Icons.outbox),
                  label: const Text('Request to Borrow Book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final success = data.requestBorrow(book.id, member);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Borrow request submitted to librarian!'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    }
                  },
                )
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.bookmark_add),
                  label: const Text('Reserve Unavailable Book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.orange.shade800,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final success = data.reserveBook(book.id, member);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book hold reservation placed successfully!'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You already have an active hold on this book.')),
                      );
                    }
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
