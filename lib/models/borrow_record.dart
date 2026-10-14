enum BorrowStatus { requested, issued, returned, overdue }

class BorrowRecord {
  final String id;
  final String bookId;
  final String bookTitle;
  final String memberId;
  final String memberName;
  final DateTime issueDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final BorrowStatus status;

  const BorrowRecord({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.memberId,
    required this.memberName,
    required this.issueDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
  });

  bool get isOverdue {
    if (status == BorrowStatus.returned) return false;
    return DateTime.now().isAfter(dueDate);
  }

  int get overdueDays {
    if (!isOverdue) return 0;
    final endDate = returnDate ?? DateTime.now();
    return endDate.difference(dueDate).inDays;
  }

  BorrowRecord copyWith({
    String? id,
    String? bookId,
    String? bookTitle,
    String? memberId,
    String? memberName,
    DateTime? issueDate,
    DateTime? dueDate,
    DateTime? returnDate,
    BorrowStatus? status,
  }) {
    return BorrowRecord(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
      status: status ?? this.status,
    );
  }
}
