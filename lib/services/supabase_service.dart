import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Convenient global reference to the Supabase client
final supabase = Supabase.instance.client;

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  // ----------------------------------------------------
  // Books Collection / Table
  // ----------------------------------------------------
  /// Fetch all books ordered by creation date descending
  static Future<List<Map<String, dynamic>>> fetchBooks() async {
    try {
      final data = await client
          .from('books')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Supabase fetchBooks error: $e');
      rethrow;
    }
  }

  /// Check whether an ISBN already exists in the books table
  static Future<bool> checkIsbnExists(String isbn) async {
    final cleanIsbn = isbn.trim();
    if (cleanIsbn.isEmpty) return false;
    try {
      final List<dynamic> data = await client
          .from('books')
          .select('id')
          .eq('isbn', cleanIsbn)
          .limit(1);
      return data.isNotEmpty;
    } catch (e) {
      debugPrint('Supabase checkIsbnExists error: $e');
      return false;
    }
  }

  /// Upload cover image binary to Supabase Storage bucket 'book-covers'
  /// Returns the public URL on success, or null if storage fails/is unavailable.
  static Future<String?> uploadBookCover(
    Uint8List bytes,
    String fileExtension,
  ) async {
    try {
      final fileName = 'cover_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = 'books/$fileName';

      String contentType = 'image/jpeg';
      final ext = fileExtension.toLowerCase().replaceAll('.', '');
      if (ext == 'png') {
        contentType = 'image/png';
      } else if (ext == 'webp') {
        contentType = 'image/webp';
      }

      await client.storage.from('book-covers').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: true,
            ),
          );

      final publicUrl = client.storage.from('book-covers').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      debugPrint('Supabase uploadBookCover error: $e');
      return null;
    }
  }

  /// Insert a new book record into the 'books' table
  static Future<void> insertBook(Map<String, dynamic> bookData) async {
    try {
      await client.from('books').insert(bookData);
    } catch (e) {
      debugPrint('Supabase insertBook error: $e');
      rethrow;
    }
  }

  /// Update an existing book record
  static Future<void> updateBook(dynamic id, Map<String, dynamic> updates) async {
    try {
      await client.from('books').update(updates).eq('id', id);
    } catch (e) {
      debugPrint('Supabase updateBook error: $e');
      rethrow;
    }
  }

  /// Delete a book record by id
  static Future<void> deleteBook(dynamic id) async {
    try {
      await client.from('books').delete().eq('id', id);
    } catch (e) {
      debugPrint('Supabase deleteBook error: $e');
      rethrow;
    }
  }

  // ----------------------------------------------------
  // Members Collection / Table
  // ----------------------------------------------------
  static Future<List<Map<String, dynamic>>> fetchMembers() async {
    try {
      final data = await client.from('members').select();
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Supabase fetchMembers error: $e');
      rethrow;
    }
  }

  static Future<void> insertMember(Map<String, dynamic> memberData) async {
    try {
      await client.from('members').insert(memberData);
    } catch (e) {
      debugPrint('Supabase insertMember error: $e');
      rethrow;
    }
  }
}
