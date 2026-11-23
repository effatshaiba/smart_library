import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String initialRole;

  const RegistrationScreen({
    super.key,
    this.initialRole = 'Member / Student',
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Common controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Admin-specific controllers (Opening a new library)
  final _libraryNameController = TextEditingController();
  final _libraryLocationController = TextEditingController();
  final _staffIdController = TextEditingController();

  // Member/Student-specific controllers
  final _studentIdController = TextEditingController();
  final _departmentController = TextEditingController();

  late String _selectedRole;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  bool get _isAdmin => _selectedRole == 'Admin / Staff';

  void _navigateToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialRole.toLowerCase().contains('admin')) {
      _selectedRole = 'Admin / Staff';
    } else {
      _selectedRole = 'Member / Student';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _libraryNameController.dispose();
    _libraryLocationController.dispose();
    _staffIdController.dispose();
    _studentIdController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _switchRole(String role) {
    if (_selectedRole == role) return;
    setState(() {
      _selectedRole = role;
      // Clear role-specific validation messages when switching tabs
      _formKey.currentState?.reset();
    });
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String? uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('User ID could not be retrieved after registration.');
      }

      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      final firestore = FirebaseFirestore.instance;

      // Prepare role-specific profile payload for Firestore
      final Map<String, dynamic> profileData = {
        'uid': uid,
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _isAdmin ? 'admin' : 'member',
        'createdAt': FieldValue.serverTimestamp(),
        if (_isAdmin) ...{
          'libraryName': _libraryNameController.text.trim(),
          'libraryLocation': _libraryLocationController.text.trim(),
          'staffId': _staffIdController.text.trim(),
          'libraryStatus': 'open',
        } else ...{
          'studentId': _studentIdController.text.trim(),
          'department': _departmentController.text.trim(),
        },
      };

      // Save user document in `users` collection using UID as document ID
      await firestore.collection('users').doc(uid).set(profileData);

      // If Admin, also create a library entry in `libraries` collection
      if (_isAdmin) {
        await firestore.collection('libraries').add({
          'adminUid': uid,
          'adminName': _nameController.text.trim(),
          'adminEmail': _emailController.text.trim(),
          'staffId': _staffIdController.text.trim(),
          'libraryName': _libraryNameController.text.trim(),
          'libraryLocation': _libraryLocationController.text.trim(),
          'status': 'open',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      debugPrint('Saved Profile Data to Firestore: $profileData');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isAdmin
                ? 'Library "${_libraryNameController.text.trim()}" opened & admin account created!'
                : 'Member account created successfully! Please sign in.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed. Please try again.';
      if (e.code == 'weak-password') {
        message = 'Password must be at least 6 characters.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.message != null) {
        message = e.message!;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Database error: ${e.message ?? e.code}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0077B6);
    const bgLight = Color(0xFFF4F7FA);

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: _navigateToLogin,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Logo Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    Icon(Icons.menu_book_rounded,
                        size: 36, color: primaryBlue),
                    SizedBox(height: 4),
                    Text(
                      'SMART LIBRARY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'ENDLESS READING',
                      style: TextStyle(
                        fontSize: 7,
                        letterSpacing: 1.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Header based on selected registration type
              Text(
                _isAdmin ? 'Open a Library' : 'Member Registration',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isAdmin
                    ? 'Register as an admin, enter your library details,\nand open your library workspace.'
                    : 'Create your member account to browse books,\ntrack active loans, and manage resources.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role Switcher
                      const Text(
                        'Register As',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _buildRoleTab(
                              title: 'Admin / Staff',
                              icon: Icons.admin_panel_settings_outlined,
                              primaryBlue: primaryBlue,
                            ),
                            _buildRoleTab(
                              title: 'Member / Student',
                              icon: Icons.person_outline,
                              primaryBlue: primaryBlue,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Separate Form Content for Admin vs Member
                      if (_isAdmin)
                        _buildAdminFormFields(primaryBlue)
                      else
                        _buildMemberFormFields(primaryBlue),

                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  _isAdmin
                                      ? 'Open Library & Register'
                                      : 'Create Member Account',
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Separate Form 1: Admin Registration (Opens a new library with Library Name)
  Widget _buildAdminFormFields(Color primaryBlue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.storefront_outlined, size: 18, color: primaryBlue),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Admin Setup: Provide your library name to open it.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Library Name *'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _libraryNameController,
          textCapitalization: TextCapitalization.words,
          decoration: _inputDecoration(
            hint: 'e.g. Central Knowledge Hub',
            icon: Icons.local_library_outlined,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your library name to open the library';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildLabel('Library Address / Branch'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _libraryLocationController,
          decoration: _inputDecoration(
            hint: 'e.g. Uttara, Dhaka',
            icon: Icons.location_on_outlined,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter library location';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildLabel('Admin / Staff Full Name'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: _inputDecoration(
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildLabel('Staff ID'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _staffIdController,
          decoration: _inputDecoration(
            hint: 'e.g. LIB-ADMIN-01',
            icon: Icons.badge_outlined,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your staff ID';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        ..._buildCommonAuthFields(),
      ],
    );
  }

  /// Separate Form 2: Member / Student Registration
  Widget _buildMemberFormFields(Color primaryBlue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.school_outlined, size: 18, color: primaryBlue),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Member Setup: Register with your Student / Member ID.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Full Name'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: _inputDecoration(
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildLabel('Student / Member ID'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _studentIdController,
          decoration: _inputDecoration(
            hint: 'e.g. CSE-2026-045',
            icon: Icons.badge_outlined,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your Student / Member ID';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildLabel('Department / Batch'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _departmentController,
          decoration: _inputDecoration(
            hint: 'e.g. CSE, 6th Semester',
            icon: Icons.menu_book_outlined,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your department or batch';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        ..._buildCommonAuthFields(),
      ],
    );
  }

  List<Widget> _buildCommonAuthFields() {
    return [
      _buildLabel('Email Address'),
      const SizedBox(height: 8),
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: _inputDecoration(
          hint: 'name@example.com',
          icon: Icons.email_outlined,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your email address';
          }
          if (!value.contains('@') || !value.contains('.')) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      _buildLabel('Password'),
      const SizedBox(height: 8),
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: _inputDecoration(
          hint: 'Minimum 6 characters',
          icon: Icons.lock_outline,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF64748B),
              size: 20,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      _buildLabel('Confirm Password'),
      const SizedBox(height: 8),
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        decoration: _inputDecoration(
          hint: 'Re-enter your password',
          icon: Icons.lock_reset_outlined,
          suffix: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF64748B),
              size: 20,
            ),
            onPressed: () {
              setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              );
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildRoleTab({
    required String title,
    required IconData icon,
    required Color primaryBlue,
  }) {
    final isSelected = _selectedRole == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchRole(title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF334155),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0077B6), width: 1.5),
      ),
    );
  }
}