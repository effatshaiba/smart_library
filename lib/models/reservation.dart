enum ReservationStatus { pending, fulfilled, cancelled }

class Reservation {
  final String id;
  final String bookId;
  final String bookTitle;
  final String memberId;
  final String memberName;
  final DateTime reservationDate;
  final ReservationStatus status;

  const Reservation({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.memberId,
    required this.memberName,
    required this.reservationDate,
    required this.status,
  });

  Reservation copyWith({
    String? id,
    String? bookId,
    String? bookTitle,
    String? memberId,
    String? memberName,
    DateTime? reservationDate,
    ReservationStatus? status,
  }) {
    return Reservation(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      reservationDate: reservationDate ?? this.reservationDate,
      status: status ?? this.status,
    );
  }
}
