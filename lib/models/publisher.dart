class Publisher {
  final String id;
  final String name;
  final String address;

  const Publisher({
    required this.id,
    required this.name,
    required this.address,
  });

  Publisher copyWith({
    String? id,
    String? name,
    String? address,
  }) {
    return Publisher(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }
}
