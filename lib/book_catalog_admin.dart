import 'dart:convert';
import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'circulation.dart';
import 'admin_profile.dart';
import 'placeholder_screen.dart';
import 'screens/shared/notifications_screen.dart';
import 'add_book.dart';
import 'services/supabase_service.dart';

class BookCatalogScreen extends StatefulWidget {
  const BookCatalogScreen({super.key});

  @override
  State<BookCatalogScreen> createState() => _BookCatalogScreenState();
}

class _BookCatalogScreenState extends State<BookCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategoryChip = 'All Books';
  bool _isLoading = true;

  // Initial fallback books to ensure rich UI if database is freshly created or empty
  final List<Map<String, dynamic>> _defaultBooks = [
    {
      'id': 'seed_1',
      'title': 'Introduction to Algorithms (4th Ed.)',
      'author': 'Thomas H. Cormen, Charles E. Leiserson',
      'category': 'Computer Science & Software',
      'shelf_number': 'CS-B2-04',
      'total_copies': 5,
      'circulation': 1,
      'available_copies': 4,
      'created_at': '2024-10-14T10:00:00Z',
    },
    {
      'id': 'seed_2',
      'title': 'Clean Architecture',
      'author': 'Robert C. Martin',
      'category': 'Software Engineering',
      'shelf_number': 'SE-A1-12',
      'total_copies': 3,
      'circulation': 3,
      'available_copies': 0,
      'created_at': '2024-10-12T10:00:00Z',
    },
    {
      'id': 'seed_3',
      'title': 'Principles of Neural Science (5th Ed.)',
      'author': 'Eric R. Kandel, James H. Schwartz',
      'category': 'Neuroscience & Medicine',
      'shelf_number': 'MED-C3-08',
      'total_copies': 4,
      'circulation': 2,
      'available_copies': 2,
      'created_at': '2024-10-10T10:00:00Z',
    },
  ];

  List<Map<String, dynamic>> _allBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseBooks = await SupabaseService.fetchBooks();

      if (mounted) {
        setState(() {
          if (supabaseBooks.isNotEmpty) {
            _allBooks = List<Map<String, dynamic>>.from(supabaseBooks);
          } else {
            _allBooks = List<Map<String, dynamic>>.from(_defaultBooks);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Book catalog fetch error: $e');
      if (mounted) {
        setState(() {
          _allBooks = List<Map<String, dynamic>>.from(_defaultBooks);
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filteredBooks {
    return _allBooks.where((book) {
      final title = (book['title'] ?? '').toString().toLowerCase();
      final author = (book['author'] ?? '').toString().toLowerCase();
      final isbn = (book['isbn'] ?? '').toString().toLowerCase();
      final category = (book['category'] ?? '').toString().toLowerCase();
      final shelf = (book['shelf_number'] ?? '').toString().toLowerCase();

      final matchesSearch = _searchQuery.isEmpty ||
          title.contains(_searchQuery) ||
          author.contains(_searchQuery) ||
          isbn.contains(_searchQuery) ||
          category.contains(_searchQuery) ||
          shelf.contains(_searchQuery);

      if (!matchesSearch) return false;

      if (_selectedCategoryChip == 'All Books') return true;
      if (_selectedCategoryChip == 'Categories') return true;
      if (_selectedCategoryChip == 'Authors') return true;
      if (_selectedCategoryChip == 'Publishers') return true;

      return category.contains(_selectedCategoryChip.toLowerCase());
    }).toList();
  }

  int get _totalCopiesCount {
    return _allBooks.fold<int>(0, (sum, book) {
      final copies = book['total_copies'];
      if (copies is int) return sum + copies;
      if (copies is String) return sum + (int.tryParse(copies) ?? 0);
      return sum;
    });
  }

  Future<void> _deleteBook(dynamic id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Book', style: TextStyle(color: Colors.blue.shade900)),
        content: Text('Are you sure you want to delete "$title" from the catalog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await SupabaseService.deleteBook(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$title" deleted successfully.'),
              backgroundColor: Colors.red.shade700,
            ),
          );
          _loadBooks();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _allBooks.removeWhere((b) => b['id'] == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removed "$title" from view.'),
              backgroundColor: Colors.grey.shade800,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksToDisplay = _filteredBooks;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade900),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMART LIBRARY',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'ENDLESS READING',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            tooltip: 'Refresh Books',
            onPressed: _loadBooks,
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceholderScreen(title: 'Dark Mode Settings'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadBooks,
        color: Colors.blue.shade700,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Catalog',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      Text(
                        'Inventory & Circulation Management',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, size: 16, color: Colors.cyan.shade800),
                        const SizedBox(width: 4),
                        Text(
                          'Admin View',
                          style: TextStyle(
                            color: Colors.cyan.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search books by title, ISBN, author...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : const Icon(Icons.qr_code_scanner),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _showFilterBottomSheet();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.tune, color: Colors.blue.shade700),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Category Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('All Books', _selectedCategoryChip == 'All Books'),
                    _buildChip('Categories', _selectedCategoryChip == 'Categories'),
                    _buildChip('Authors', _selectedCategoryChip == 'Authors'),
                    _buildChip('Publishers', _selectedCategoryChip == 'Publishers'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Summary Row
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: Colors.blue.shade700),
                  const SizedBox(width: 4),
                  Text(
                    '${_allBooks.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(' Titles  •  '),
                  Text(
                    '$_totalCopiesCount',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(' Copies'),
                  const Spacer(),
                  Text(
                    'Sort: Recently Added',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade700, size: 18),
                ],
              ),
              const SizedBox(height: 16),

              // Loading State or Empty State or Books List
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (booksToDisplay.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.menu_book, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No books found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'No results matching "$_searchQuery"'
                            : 'Click "Add Book" below to add your first book!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: booksToDisplay.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final book = booksToDisplay[index];
                    return _buildDynamicBookCard(context, book);
                  },
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Fixed Floating Action Button (no static method tear-off)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddBookScreen(onSave: SupabaseService.insertBook),
            ),
          );
          if (added == true) {
            _loadBooks();
          }
        },
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Book', style: TextStyle(color: Colors.white)),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CirculationScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Circulation'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryChip = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicBookCard(BuildContext context, Map<String, dynamic> book) {
    final title = book['title'] ?? 'Untitled Book';
    final author = book['author'] ?? 'Unknown Author';
    final category = book['category'] ?? 'General';
    final shelf = (book['shelf_number'] ?? 'N/A').toString();

    final totalCopies = (book['total_copies'] ?? 1).toString();
    final circulation = (book['circulation'] ?? 0).toString();
    final availableCopies = (book['available_copies'] ?? totalCopies).toString();

    final availInt = int.tryParse(availableCopies) ?? 0;
    final isAvailable = availInt > 0;
    final statusText = isAvailable ? 'Available • $availableCopies Copies' : 'Out of Stock • 0 Available';
    final statusColor = isAvailable ? Colors.green : Colors.orange;

    final coverImageUrl = book['cover_image_url'] as String?;
    final createdAt = book['created_at'] != null
        ? _formatDate(book['created_at'].toString())
        : 'Oct 14, 2024';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverThumbnail(coverImageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(author, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Category: $category',
                      style: TextStyle(color: Colors.blue.shade900, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn('SHELF', shelf, Colors.blue.shade900),
                _buildStatColumn('TOTAL', totalCopies, Colors.blue.shade900),
                _buildStatColumn('CIRCULATION', circulation, Colors.cyan),
                _buildStatColumn('IN LIBRARY', availableCopies, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Added: $createdAt',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceholderScreen(title: 'Edit Book: $title'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _deleteBook(book['id'], title),
                    icon: const Icon(Icons.delete, size: 14),
                    label: const Text('Delete', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(color: Colors.red.shade100),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCoverThumbnail(String? coverImageUrl) {
    if (coverImageUrl != null && coverImageUrl.isNotEmpty) {
      if (coverImageUrl.startsWith('http://') || coverImageUrl.startsWith('https://')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            coverImageUrl,
            width: 60,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholderCover(),
          ),
        );
      } else if (coverImageUrl.startsWith('data:image')) {
        try {
          final commaIndex = coverImageUrl.indexOf(',');
          final base64Data = commaIndex != -1 ? coverImageUrl.substring(commaIndex + 1) : coverImageUrl;
          final bytes = base64Decode(base64Data);
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              bytes,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholderCover(),
            ),
          );
        } catch (_) {
          return _buildPlaceholderCover();
        }
      }
    }
    return _buildPlaceholderCover();
  }

  Widget _buildPlaceholderCover() {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.menu_book, color: Colors.blue.shade700, size: 28),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return 'Recently';
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'All Books',
                'Computer Science',
                'Software Engineering',
                'Neuroscience',
                'Art & Design',
                'Mathematics',
                'Literature',
              ].map((cat) {
                final isSelected = _selectedCategoryChip == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.blue.shade700,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) {
                    setState(() {
                      _selectedCategoryChip = cat;
                    });
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}