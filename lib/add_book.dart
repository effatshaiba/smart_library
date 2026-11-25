import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_library/services/supabase_service.dart';

class AddBookScreen extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic>)? onSave;

  const AddBookScreen({
    super.key,
    this.onSave,
  });

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();
  final _copiesController = TextEditingController(text: '1');
  final _shelfController = TextEditingController();
  final _descriptionController = TextEditingController();

  XFile? _coverImage;
  Uint8List? _coverImageBytes;
  String? _selectedCategory;
  bool _isSaving = false;

  final List<String> _categories = [
    'Computer Science',
    'Programming',
    'Software Engineering',
    'Database',
    'Networking',
    'Mathematics',
    'Science',
    'Literature',
    'History',
    'Business',
    'Other',
  ];

  final Color primaryBlue = const Color(0xFF2467A5);
  final Color lightBlue = const Color(0xFFE8F5FC);
  final Color textColor = const Color(0xFF244D75);

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _copiesController.dispose();
    _shelfController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
    String hint, {
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: primaryBlue, size: 20)
          : null,
      filled: true,
      fillColor: const Color(0xFFF8FBFE),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          children: [
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool required = false,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: required),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14),
          decoration: _inputDecoration(hint, icon: icon),
          validator: validator ??
              (required
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '$label is required';
                      }
                      return null;
                    }
                  : null),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryBlue, size: 21),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBookCoverUpload() {
    return Stack(
      children: [
        InkWell(
          onTap: _pickCoverImage,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: primaryBlue.withOpacity(0.35),
                width: 1.2,
              ),
            ),
            child: _coverImageBytes == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.cloud_upload_outlined,
                          color: primaryBlue,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload Book Cover',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Tap to select an image from gallery',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'JPG, PNG supported',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.memory(
                      _coverImageBytes!,
                      width: double.infinity,
                      height: 190,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        if (_coverImageBytes != null)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton.filled(
              tooltip: 'Remove cover image',
              onPressed: _removeCoverImage,
              icon: const Icon(Icons.close),
            ),
          ),
      ],
    );
  }

  Future<void> _pickCoverImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _coverImage = image;
        _coverImageBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select cover image: $e')),
      );
    }
  }

  void _removeCoverImage() {
    setState(() {
      _coverImage = null;
      _coverImageBytes = null;
    });
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final copies = int.tryParse(_copiesController.text.trim());

    if (copies == null || copies <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Total copies must be greater than zero'),
        ),
      );
      return;
    }

    final yearText = _yearController.text.trim();
    int? parsedYear;

    if (yearText.isNotEmpty) {
      parsedYear = int.tryParse(yearText);
      if (parsedYear == null ||
          parsedYear < 1000 ||
          parsedYear > DateTime.now().year) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid publication year')),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      String? coverImageUrl;
      var coverUploadFailed = false;
      if (_coverImageBytes != null && _coverImage != null) {
        final name = _coverImage!.name;
        final extensionIndex = name.lastIndexOf('.');
        final extension = extensionIndex == -1
            ? 'jpg'
            : name.substring(extensionIndex + 1).toLowerCase();
        try {
          coverImageUrl = await SupabaseService.uploadBookCover(
            _coverImageBytes!,
            extension,
          );
        } catch (e, stackTrace) {
          coverUploadFailed = true;
          debugPrint('Book cover upload failed: $e\n$stackTrace');
        }
        if (coverImageUrl == null) {
          coverUploadFailed = true;
          debugPrint(
            'Book cover upload returned no URL. Check the Supabase '
            '"book-covers" bucket and its upload policies.',
          );
        }
      }

      final bookData = <String, dynamic>{
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'isbn': _isbnController.text.trim(),
        'publisher': _publisherController.text.trim(),
        'category': _selectedCategory,
        'publication_year': parsedYear ?? yearText,
        'total_copies': copies,
        'available_copies': copies,
        'circulation': 0,
        'shelf_number': _shelfController.text.trim(),
        'description': _descriptionController.text.trim(),
      };
      if (coverImageUrl != null) {
        bookData['cover_image_url'] = coverImageUrl;
      }

      if (widget.onSave != null) {
        await widget.onSave!(bookData);
      } else {
        await SupabaseService.insertBook(bookData);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            coverUploadFailed
                ? 'Book saved, but the cover could not be uploaded.'
                : 'Book saved successfully!',
          ),
          backgroundColor:
              coverUploadFailed ? Colors.orange.shade800 : Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save book: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F5FC),
        foregroundColor: textColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMART LIBRARY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'ENDLESS READING',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Book',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add a new book to your library inventory',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 22),

                // Book Information
                _buildSection(
                  title: 'Book Information',
                  icon: Icons.menu_book_rounded,
                  children: [
                    _buildLabel('Book Cover'),
                    _buildBookCoverUpload(),
                    const SizedBox(height: 20),

                    _buildTextField(
                      label: 'Book Title',
                      hint: 'Enter book title',
                      controller: _titleController,
                      required: true,
                      icon: Icons.book_outlined,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Author Name',
                      hint: 'Enter author name',
                      controller: _authorController,
                      required: true,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'ISBN',
                      hint: 'Enter ISBN number',
                      controller: _isbnController,
                      icon: Icons.qr_code,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Publisher',
                      hint: 'Enter publisher name',
                      controller: _publisherController,
                      icon: Icons.business_outlined,
                    ),
                    const SizedBox(height: 18),

                    _buildLabel('Category', required: true),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      decoration: _inputDecoration(
                        'Select book category',
                        icon: Icons.category_outlined,
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Publication Year',
                      hint: 'e.g. 2024',
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Description',
                      hint: 'Write a short book description',
                      controller: _descriptionController,
                      maxLines: 4,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Inventory Information
                _buildSection(
                  title: 'Inventory Information',
                  icon: Icons.inventory_2_outlined,
                  children: [
                    _buildTextField(
                      label: 'Total Copies',
                      hint: 'Enter number of copies',
                      controller: _copiesController,
                      required: true,
                      keyboardType: TextInputType.number,
                      icon: Icons.library_books_outlined,
                      validator: (value) {
                        final number = int.tryParse(value ?? '');
                        if (number == null || number <= 0) {
                          return 'Enter a valid number of copies';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Shelf Number',
                      hint: 'e.g. CS-B2-04',
                      controller: _shelfController,
                      required: true,
                      icon: Icons.shelves,
                    ),
                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'New books will initially have 0 borrowed copies. '
                              'All copies will be available in the library.',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveBook,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 19,
                            height: 19,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isSaving ? 'Saving...' : 'Save Book',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryBlue,
                      side: BorderSide(color: primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}