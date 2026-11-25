import 'package:supabase_flutter/supabase_flutter.dart';

/// Convenient global reference to the Supabase client
final supabase = Supabase.instance.client;

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  // ----------------------------------------------------
  // Books Collection / Table
  // ----------------------------------------------------
  static Future<List<Map<String, dynamic>>> fetchBooks() async {
    final data = await client.from('books').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> insertBook(Map<String, dynamic> bookData) async {
    await client.from('books').insert(bookData);
  }

  static Future<void> updateBook(int id, Map<String, dynamic> updates) async {
    await client.from('books').update(updates).eq('id', id);
  }

  static Future<void> deleteBook(int id) async {
    await client.from('books').delete().eq('id', id);
  }

  // ----------------------------------------------------
  // Members Collection / Table
  // ----------------------------------------------------
  static Future<List<Map<String, dynamic>>> fetchMembers() async {
    final data = await client.from('members').select();
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> insertMember(Map<String, dynamic> memberData) async {
    await client.from('members').insert(memberData);
  }
}
