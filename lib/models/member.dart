enum UserRole { admin, member }

class Member {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final String department;
  final String phone;
  final bool isActive;
  final UserRole role;
  final String? avatarUrl;

  const Member({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.department,
    required this.phone,
    this.isActive = true,
    this.role = UserRole.member,
    this.avatarUrl,
  });

  Member copyWith({
    String? id,
    String? name,
    String? email,
    String? studentId,
    String? department,
    String? phone,
    bool? isActive,
    UserRole? role,
    String? avatarUrl,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
