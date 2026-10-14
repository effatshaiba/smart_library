import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../models/author.dart';
import '../models/publisher.dart';
import '../models/member.dart';
import '../models/borrow_record.dart';
import '../models/reservation.dart';
import '../models/fine_record.dart';
import '../models/notification_model.dart';

class LibraryDataProvider extends ChangeNotifier {
  // Lists
  final List<Category> _categories = [];
  final List<Author> _authors = [];
  final List<Publisher> _publishers = [];
  final List<Book> _books = [];
  final List<Member> _members = [];
  final List<BorrowRecord> _borrowRecords = [];
  final List<Reservation> _reservations = [];
  final List<FineRecord> _fineRecords = [];
  final List<NotificationModel> _notifications = [];

  // Fine Rate per day
  final double fineRatePerDay = 10.0; // BDT 10/day

  LibraryDataProvider() {
    _seedInitialData();
  }

  // Getters
  List<Category> get categories => List.unmodifiable(_categories);
  List<Author> get authors => List.unmodifiable(_authors);
  List<Publisher> get publishers => List.unmodifiable(_publishers);
  List<Book> get books => List.unmodifiable(_books);
  List<Member> get members => List.unmodifiable(_members);
  List<BorrowRecord> get borrowRecords => List.unmodifiable(_borrowRecords);
  List<Reservation> get reservations => List.unmodifiable(_reservations);
  List<FineRecord> get fineRecords => List.unmodifiable(_fineRecords);
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  // Statistics
  int get totalBooks => _books.fold(0, (sum, book) => sum + book.totalCopies);
  int get availableBooks => _books.fold(0, (sum, book) => sum + book.availableCopies);
  int get activeBorrowings => _borrowRecords.where((b) => b.status == BorrowStatus.issued || b.status == BorrowStatus.overdue).length;
  int get overdueBooks => _borrowRecords.where((b) => b.isOverdue || b.status == BorrowStatus.overdue).length;
  int get totalMembers => _members.length;
  int get activeMembers => _members.where((m) => m.isActive).length;
  double get totalPendingFines => _fineRecords
      .where((f) => f.status == FineStatus.pending)
      .fold(0.0, (sum, fine) => sum + fine.amount);
  int get pendingReservations => _reservations.where((r) => r.status == ReservationStatus.pending).length;

  // Filtered queries for Members
  List<BorrowRecord> getMemberBorrows(String memberId) {
    return _borrowRecords.where((b) => b.memberId == memberId).toList();
  }

  List<Reservation> getMemberReservations(String memberId) {
    return _reservations.where((r) => r.memberId == memberId).toList();
  }

  List<FineRecord> getMemberFines(String memberId) {
    return _fineRecords.where((f) => f.memberId == memberId).toList();
  }

  List<NotificationModel> getMemberNotifications(String memberId) {
    return _notifications
        .where((n) => n.recipientMemberId == null || n.recipientMemberId == memberId)
        .toList();
  }

  // Seed Realistic Initial Data
  void _seedInitialData() {
    // Categories
    _categories.addAll([
      const Category(id: 'cat_1', name: 'Computer Science & Software', description: 'Programming, Algorithms, Software Engineering'),
      const Category(id: 'cat_2', name: 'Art & Design', description: 'Visual arts, graphic design, animation'),
      const Category(id: 'cat_3', name: 'Mathematics & Statistics', description: 'Calculus, Linear Algebra, Discrete Math'),
      const Category(id: 'cat_4', name: 'Literature & Fiction', description: 'Novels, classics, world literature'),
    ]);

    // Authors
    _authors.addAll([
      const Author(id: 'auth_1', name: 'Robert C. Martin', bio: 'Uncle Bob, author of Clean Code and Clean Architecture'),
      const Author(id: 'auth_2', name: 'Erich Gamma', bio: 'Co-author of Design Patterns (Gang of Four)'),
      const Author(id: 'auth_3', name: 'Donald Knuth', bio: 'Author of The Art of Computer Programming'),
      const Author(id: 'auth_4', name: 'Josef Albers', bio: 'Renowned designer and artist, author of Interaction of Color'),
    ]);

    // Publishers
    _publishers.addAll([
      const Publisher(id: 'pub_1', name: 'Prentice Hall', address: 'Upper Saddle River, NJ'),
      const Publisher(id: 'pub_2', name: 'Addison-Wesley', address: 'Boston, MA'),
      const Publisher(id: 'pub_3', name: 'Yale University Press', address: 'New Haven, CT'),
      const Publisher(id: 'pub_4', name: 'O\'Reilly Media', address: 'Sebastopol, CA'),
    ]);

    // Books
    _books.addAll([
      const Book(
        id: 'book_1',
        title: 'Clean Code: A Handbook of Agile Software Craftsmanship',
        isbn: '978-0132350884',
        categoryId: 'cat_1',
        categoryName: 'Computer Science & Software',
        authorId: 'auth_1',
        authorName: 'Robert C. Martin',
        publisherId: 'pub_1',
        publisherName: 'Prentice Hall',
        description: 'Even bad code can function. But if code isn\'t clean, it can bring a development organization to its knees.',
        totalCopies: 5,
        availableCopies: 3,
      ),
      const Book(
        id: 'book_2',
        title: 'Design Patterns: Elements of Reusable Object-Oriented Software',
        isbn: '978-0201633610',
        categoryId: 'cat_1',
        categoryName: 'Computer Science & Software',
        authorId: 'auth_2',
        authorName: 'Erich Gamma',
        publisherId: 'pub_2',
        publisherName: 'Addison-Wesley',
        description: 'Captures a wealth of experience in building object-oriented software design patterns.',
        totalCopies: 4,
        availableCopies: 1,
      ),
      const Book(
        id: 'book_3',
        title: 'Interaction of Color',
        isbn: '978-0300179354',
        categoryId: 'cat_2',
        categoryName: 'Art & Design',
        authorId: 'auth_4',
        authorName: 'Josef Albers',
        publisherId: 'pub_3',
        publisherName: 'Yale University Press',
        description: 'A handbook and teaching guide for artists, instructors, and students in visual design.',
        totalCopies: 3,
        availableCopies: 0, // Out of stock to test reservation
      ),
      const Book(
        id: 'book_4',
        title: 'The Art of Computer Programming, Vol 1',
        isbn: '978-0201896831',
        categoryId: 'cat_1',
        categoryName: 'Computer Science & Software',
        authorId: 'auth_3',
        authorName: 'Donald Knuth',
        publisherId: 'pub_2',
        publisherName: 'Addison-Wesley',
        description: 'Fundamental algorithms and mathematical analysis of programming structures.',
        totalCopies: 2,
        availableCopies: 2,
      ),
    ]);

    // Members
    _members.addAll([
      const Member(
        id: 'mem_1',
        name: 'Effat Binte Emran Shaiba',
        email: 'effat.241071007@smuct.edu.bd',
        studentId: '241071007',
        department: 'CSE',
        phone: '+880 1812 345678',
        isActive: true,
      ),
      const Member(
        id: 'mem_2',
        name: 'Sadia Afrin',
        email: 'sadia.241071037@smuct.edu.bd',
        studentId: '241071037',
        department: 'CSE & CSIT',
        phone: '+880 1712 987654',
        isActive: true,
      ),
      const Member(
        id: 'mem_3',
        name: 'Tanvir Hossain',
        email: 'tanvir.cse@smuct.edu.bd',
        studentId: '241071099',
        department: 'CSE',
        phone: '+880 1911 223344',
        isActive: false, // Inactive user test
      ),
    ]);

    // Borrow Records
    _borrowRecords.addAll([
      BorrowRecord(
        id: 'borrow_1',
        bookId: 'book_1',
        bookTitle: 'Clean Code: A Handbook of Agile Software Craftsmanship',
        memberId: 'mem_1',
        memberName: 'Effat Binte Emran Shaiba',
        issueDate: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().add(const Duration(days: 9)),
        status: BorrowStatus.issued,
      ),
      BorrowRecord(
        id: 'borrow_2',
        bookId: 'book_2',
        bookTitle: 'Design Patterns: Elements of Reusable Object-Oriented Software',
        memberId: 'mem_1',
        memberName: 'Effat Binte Emran Shaiba',
        issueDate: DateTime.now().subtract(const Duration(days: 20)),
        dueDate: DateTime.now().subtract(const Duration(days: 6)), // Overdue
        status: BorrowStatus.overdue,
      ),
    ]);

    // Fine Record for Overdue Borrow
    _fineRecords.add(
      const FineRecord(
        id: 'fine_1',
        borrowRecordId: 'borrow_2',
        memberId: 'mem_1',
        memberName: 'Effat Binte Emran Shaiba',
        bookTitle: 'Design Patterns: Elements of Reusable Object-Oriented Software',
        amount: 60.0, // 6 days * 10 BDT
        overdueDays: 6,
        status: FineStatus.pending,
      ),
    );

    // Reservation
    _reservations.add(
      Reservation(
        id: 'res_1',
        bookId: 'book_3',
        bookTitle: 'Interaction of Color',
        memberId: 'mem_1',
        memberName: 'Effat Binte Emran Shaiba',
        reservationDate: DateTime.now().subtract(const Duration(days: 1)),
        status: ReservationStatus.pending,
      ),
    );

    // Notifications
    _notifications.addAll([
      NotificationModel(
        id: 'notif_1',
        title: 'Overdue Book Reminder',
        message: 'Your borrowed book "Design Patterns" is 6 days overdue. Please return it to avoid further fines.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        recipientMemberId: 'mem_1',
      ),
      NotificationModel(
        id: 'notif_2',
        title: 'Library Announcement',
        message: 'The library will remain open until 8:00 PM during mid-term exam week.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  // --- CATALOG MANAGEMENT ACTIONS ---
  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((b) => b.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  void deleteBook(String bookId) {
    _books.removeWhere((b) => b.id == bookId);
    notifyListeners();
  }

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(Category category) {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void addAuthor(Author author) {
    _authors.add(author);
    notifyListeners();
  }

  void updateAuthor(Author author) {
    final index = _authors.indexWhere((a) => a.id == author.id);
    if (index != -1) {
      _authors[index] = author;
      notifyListeners();
    }
  }

  void deleteAuthor(String id) {
    _authors.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void addPublisher(Publisher publisher) {
    _publishers.add(publisher);
    notifyListeners();
  }

  void updatePublisher(Publisher publisher) {
    final index = _publishers.indexWhere((p) => p.id == publisher.id);
    if (index != -1) {
      _publishers[index] = publisher;
      notifyListeners();
    }
  }

  void deletePublisher(String id) {
    _publishers.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // --- MEMBER MANAGEMENT ACTIONS ---
  void addMember(Member member) {
    _members.add(member);
    notifyListeners();
  }

  void updateMember(Member updatedMember) {
    final index = _members.indexWhere((m) => m.id == updatedMember.id);
    if (index != -1) {
      _members[index] = updatedMember;
      notifyListeners();
    }
  }

  void toggleMemberStatus(String memberId) {
    final index = _members.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      final current = _members[index];
      _members[index] = current.copyWith(isActive: !current.isActive);
      notifyListeners();
    }
  }

  // --- CIRCULATION ACTIONS ---
  bool requestBorrow(String bookId, Member member) {
    final bookIndex = _books.indexWhere((b) => b.id == bookId);
    if (bookIndex == -1) return false;

    final book = _books[bookIndex];
    if (book.availableCopies <= 0) return false;

    final record = BorrowRecord(
      id: 'borrow_${DateTime.now().millisecondsSinceEpoch}',
      bookId: book.id,
      bookTitle: book.title,
      memberId: member.id,
      memberName: member.name,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: BorrowStatus.requested,
    );

    _borrowRecords.add(record);
    notifyListeners();
    return true;
  }

  bool issueBook(String borrowRecordId) {
    final index = _borrowRecords.indexWhere((b) => b.id == borrowRecordId);
    if (index == -1) return false;

    final record = _borrowRecords[index];
    final bookIndex = _books.indexWhere((b) => b.id == record.bookId);
    if (bookIndex == -1) return false;

    final book = _books[bookIndex];
    if (book.availableCopies <= 0) return false;

    // Decrement available copies
    _books[bookIndex] = book.copyWith(availableCopies: book.availableCopies - 1);

    _borrowRecords[index] = record.copyWith(
      status: BorrowStatus.issued,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
    );

    notifyListeners();
    return true;
  }

  bool processReturn(String borrowRecordId) {
    final index = _borrowRecords.indexWhere((b) => b.id == borrowRecordId);
    if (index == -1) return false;

    final record = _borrowRecords[index];
    final returnDate = DateTime.now();

    // Increment book available copies
    final bookIndex = _books.indexWhere((b) => b.id == record.bookId);
    if (bookIndex != -1) {
      final book = _books[bookIndex];
      _books[bookIndex] = book.copyWith(availableCopies: book.availableCopies + 1);
    }

    // Check fine
    if (returnDate.isAfter(record.dueDate)) {
      final overdueDays = returnDate.difference(record.dueDate).inDays;
      if (overdueDays > 0) {
        final fineAmount = overdueDays * fineRatePerDay;
        _fineRecords.add(
          FineRecord(
            id: 'fine_${DateTime.now().millisecondsSinceEpoch}',
            borrowRecordId: record.id,
            memberId: record.memberId,
            memberName: record.memberName,
            bookTitle: record.bookTitle,
            amount: fineAmount,
            overdueDays: overdueDays,
            status: FineStatus.pending,
          ),
        );
      }
    }

    _borrowRecords[index] = record.copyWith(
      status: BorrowStatus.returned,
      returnDate: returnDate,
    );

    notifyListeners();
    return true;
  }

  // --- RESERVATION ACTIONS ---
  bool reserveBook(String bookId, Member member) {
    final book = _books.firstWhere((b) => b.id == bookId, orElse: () => throw Exception('Book not found'));

    // Check if already reserved
    final exists = _reservations.any((r) => r.bookId == bookId && r.memberId == member.id && r.status == ReservationStatus.pending);
    if (exists) return false;

    _reservations.add(
      Reservation(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}',
        bookId: book.id,
        bookTitle: book.title,
        memberId: member.id,
        memberName: member.name,
        reservationDate: DateTime.now(),
        status: ReservationStatus.pending,
      ),
    );

    notifyListeners();
    return true;
  }

  void cancelReservation(String reservationId) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(status: ReservationStatus.cancelled);
      notifyListeners();
    }
  }

  void fulfillReservation(String reservationId) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(status: ReservationStatus.fulfilled);
      notifyListeners();
    }
  }

  // --- FINE ACTIONS ---
  void collectFine(String fineId) {
    final index = _fineRecords.indexWhere((f) => f.id == fineId);
    if (index != -1) {
      _fineRecords[index] = _fineRecords[index].copyWith(status: FineStatus.collected);
      notifyListeners();
    }
  }

  void waiveFine(String fineId) {
    final index = _fineRecords.indexWhere((f) => f.id == fineId);
    if (index != -1) {
      _fineRecords[index] = _fineRecords[index].copyWith(status: FineStatus.waived);
      notifyListeners();
    }
  }

  // --- NOTIFICATION ACTIONS ---
  void sendNotification(String title, String message, {String? recipientMemberId}) {
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        timestamp: DateTime.now(),
        recipientMemberId: recipientMemberId,
      ),
    );
    notifyListeners();
  }

  void markNotificationRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
}
