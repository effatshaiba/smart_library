import 'package:flutter/material.dart';
import '../models/member.dart';

class AuthProvider extends ChangeNotifier {
  Member? _currentUser;
  bool _isAuthenticated = true; // Default logged in for demo

  // Demo Admin Account
  static const Member defaultAdmin = Member(
    id: 'admin_1',
    name: 'Shad Al Kaisar (Admin)',
    email: 'admin@library.edu',
    studentId: 'ADM-001',
    department: 'Library Staff',
    phone: '+880 1711 000000',
    isActive: true,
    role: UserRole.admin,
  );

  // Demo Member Account
  static const Member defaultMember = Member(
    id: 'mem_1',
    name: 'Effat Binte Emran Shaiba',
    email: 'effat.241071007@smuct.edu.bd',
    studentId: '241071007',
    department: 'CSE',
    phone: '+880 1812 345678',
    isActive: true,
    role: UserRole.member,
  );

  AuthProvider() {
    _currentUser = defaultAdmin; // Start as Admin by default
  }

  Member? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated && _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isMember => _currentUser?.role == UserRole.member;

  void switchToAdmin() {
    _currentUser = defaultAdmin;
    _isAuthenticated = true;
    notifyListeners();
  }

  void switchToMember() {
    _currentUser = defaultMember;
    _isAuthenticated = true;
    notifyListeners();
  }

  bool login(String email, String password) {
    if (email.toLowerCase().contains('admin')) {
      _currentUser = defaultAdmin;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } else if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = defaultMember.copyWith(email: email);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  bool changePassword(String currentPassword, String newPassword) {
    if (currentPassword.isNotEmpty && newPassword.length >= 6) {
      notifyListeners();
      return true;
    }
    return false;
  }
}
