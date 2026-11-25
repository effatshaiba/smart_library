import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/supabase_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _publisherController = TextEditingController();
  final _pubYearController = TextEditingController();
  final _totalCopiesController = TextEditingController(text: '1');
  final _shelfController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Category Options
  final List<String> _categories = [
    'Computer Science & Software',
    'Software Engineering',
    'Neuroscience & Medicine',
    'Art & Design',
    'Mathematics & Statistics',
    'Literature & Fiction',
    'Business & Economics',
    'General Science',
  ];
  late String _selectedCategory;

  // Image State
  XFile? _pickedImage;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _pubYearController.dispose();
    _totalCopiesController.dispose();
    _shelfController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _pickedImage = image;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
      _imageBytes = null;
    });
  }

  Future<void> _saveBook() async {
    // 1. Form Validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final totalCopies = int.tryParse(_totalCopiesController.text.trim()) ?? 0;
    if (totalCopies <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Total copies must be a positive integer greater than 0.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isbn = _isbnController.text.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      // 2. Duplicate ISBN check if ISBN is provided
      if (isbn.isNotEmpty) {
        final alreadyExists = await SupabaseService.checkIsbnExists(isbn);
        if (alreadyExists) {
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('A book with ISBN "$isbn" already exists in the catalog.'),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
          return;
        }
      }

      // 3. Image handling: Upload to Supabase Storage or fallback to base64
      String? coverImageUrl;
      if (_imageBytes != null && _pickedImage != null) {
        final extension = _pickedImage!.name.split('.').last;
        // Attempt upload to Supabase storage bucket 'book-covers'
        coverImageUrl = await SupabaseService.uploadBookCover(_imageBytes!, extension);

        // Fallback: If storage bucket upload returns null, store as Base64 data URI
        if (coverImageUrl == null) {
          final base64String = base64Encode(_imageBytes!);
          coverImageUrl = 'data:image/$extension;base64,$base64String';
        }
      }

      // 4. Construct payload following requirements:
      // - Circulation set to 0
      // - In Library (available_copies) set to Total Copies
      final bookData = {
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'isbn': isbn.isEmpty ? null : isbn,
        'publisher': _publisherController.text.trim().isEmpty
            ? null
            : _publisherController.text.trim(),
        'category': _selectedCategory,
        'publication_year': _pubYearController.text.trim().isEmpty
            ? null
            : _pubYearController.text.trim(),
        'total_copies': totalCopies,
        'available_copies': totalCopies, // In Library = Total Copies
        'circulation': 0, // Circulation = 0
        'shelf_number': _shelfController.text.trim(),
        'cover_image_url': coverImageUrl,
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      };

      // 5. Insert into Supabase books table
      await SupabaseService.insertBook(bookData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('"${_titleController.text.trim()}" added to catalog!'),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context, true); // Return true to trigger auto-refresh
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        final errorMsg = e.toString();
        String displayError = 'Failed to save book: $errorMsg';
        if (errorMsg.contains('public.books') || errorMsg.contains('PGRST205')) {
          displayError =
              'Database table "books" not found in Supabase. Please run the SQL in "supabase_schema.sql" in your Supabase SQL Editor.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(displayError),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'DISMISS',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade900),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Book',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'SMART LIBRARY INVENTORY',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _saveBook,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check, size: 18),
            label: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cover Image Section
              _buildCoverImageCard(),
              const SizedBox(height: 16),

              // 2. Book Information Card
              _buildBookDetailsCard(),
              const SizedBox(height: 16),

              // 3. Inventory & Shelf Placement Card
              _buildInventoryCard(),
              const SizedBox(height: 24),

              // 4. Save and Cancel Buttons
              _buildActionButtons(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Book Cover Image',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Upload a high quality cover image from device gallery',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: _imageBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(_imageBytes!, fit: BoxFit.cover),
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 14),
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select Photo',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'JPG, PNG',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
            ),
          ),
          if (_imageBytes != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library, size: 14),
                  label: const Text('Change', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _removeImage,
                  icon: const Icon(Icons.delete_outline, size: 14),
                  label: const Text('Remove', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Book Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Title (Required)
          _buildTextField(
            controller: _titleController,
            label: 'Book Title',
            hint: 'e.g. Introduction to Algorithms',
            icon: Icons.title,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Book title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Author (Required)
          _buildTextField(
            controller: _authorController,
            label: 'Author Name',
            hint: 'e.g. Thomas H. Cormen',
            icon: Icons.person_outline,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Author name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // ISBN (Optional, validated format)
          _buildTextField(
            controller: _isbnController,
            label: 'ISBN',
            hint: 'e.g. 978-0262033848',
            icon: Icons.qr_code_2,
            isRequired: false,
            validator: (val) {
              if (val != null && val.trim().isNotEmpty) {
                final clean = val.replaceAll(RegExp(r'[-\s]'), '');
                if (clean.length != 10 && clean.length != 13) {
                  return 'Enter a valid 10 or 13-digit ISBN';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Publisher
          _buildTextField(
            controller: _publisherController,
            label: 'Publisher',
            hint: 'e.g. MIT Press',
            icon: Icons.business_outlined,
            isRequired: false,
          ),
          const SizedBox(height: 14),

          // Category Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined, color: Colors.blue.shade700, size: 20),
                  filled: true,
                  fillColor: Colors.blue.shade50.withAlpha(50),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 1.5),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Publication Year
          _buildTextField(
            controller: _pubYearController,
            label: 'Publication Year',
            hint: 'e.g. 2022',
            icon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
            isRequired: false,
            validator: (val) {
              if (val != null && val.trim().isNotEmpty) {
                final year = int.tryParse(val.trim());
                if (year == null || year < 1000 || year > DateTime.now().year + 1) {
                  return 'Enter a valid 4-digit year (e.g. 2024)';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Description
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Provide a brief summary of the book...',
            icon: Icons.description_outlined,
            maxLines: 3,
            isRequired: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Inventory & Placement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Shelf Number (Required)
          _buildTextField(
            controller: _shelfController,
            label: 'Shelf Number',
            hint: 'e.g. CS-B2-04 or AISLE-3',
            icon: Icons.location_on_outlined,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Shelf number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Total Copies (Required, positive int)
          _buildTextField(
            controller: _totalCopiesController,
            label: 'Total Copies',
            hint: 'e.g. 5',
            icon: Icons.copy_outlined,
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Total copies is required';
              }
              final parsed = int.tryParse(val.trim());
              if (parsed == null || parsed <= 0) {
                return 'Must be a positive number greater than 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Circulation Notice Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.cyan.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.cyan.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.cyan.shade800),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Automatic Inventory Allocation',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Newly created books will start with Circulation = 0 and Available in Library = Total Copies.',
                        style: TextStyle(fontSize: 11, color: Colors.cyan.shade800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade900,
              ),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: Colors.blue.shade700, size: 20),
            filled: true,
            fillColor: Colors.blue.shade50.withAlpha(50),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.shade700, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: Colors.blue.shade900,
              side: BorderSide(color: Colors.blue.shade200),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Save Book',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
