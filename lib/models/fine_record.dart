enum FineStatus { pending, collected, waived }

class FineRecord {
  final String id;
  final String borrowRecordId;
  final String memberId;
  final String memberName;
  final String bookTitle;
  final double amount;
  final int overdueDays;
  final FineStatus status;

  const FineRecord({
    required this.id,
    required this.borrowRecordId,
    required this.memberId,
    required this.memberName,
    required this.bookTitle,
    required this.amount,
    required this.overdueDays,
    required this.status,
  });

  FineRecord copyWith({
    String? id,
    String? borrowRecordId,
    String? memberId,
    String? memberName,
    String? bookTitle,
    double? amount,
    int? overdueDays,
    FineStatus? status,
  }) {
    return FineRecord(
      id: id ?? this.id,
      borrowRecordId: borrowRecordId ?? this.borrowRecordId,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      bookTitle: bookTitle ?? this.bookTitle,
      amount: amount ?? this.amount,
      overdueDays: overdueDays ?? this.overdueDays,
      status: status ?? this.status,
    );
  }
}
