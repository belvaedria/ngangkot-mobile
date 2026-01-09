class Report {
  final String id;
  final String
      category; // "KETERLAMBATAN", "FASILITAS RUSAK", "PENGEMUDI BERMASALAH", "LAINNYA"
  final String description;
  final String status; // "PENDING", "DIPROSES", "SELESAI"
  final String? imageUrl;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.category,
    required this.description,
    required this.status,
    this.imageUrl,
    required this.createdAt,
  });

  Report copyWith({
    String? id,
    String? category,
    String? description,
    String? status,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Report(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'status': status,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'PENDING',
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Report(id: $id, category: $category, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Report && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Report Category Constants
class ReportCategory {
  static const String keterlambatan = 'KETERLAMBATAN';
  static const String fasilitasRusak = 'FASILITAS RUSAK';
  static const String pengemudiBermasalah = 'PENGEMUDI BERMASALAH';
  static const String lainnya = 'LAINNYA';

  static List<String> get all => [
        keterlambatan,
        fasilitasRusak,
        pengemudiBermasalah,
        lainnya,
      ];

  static String getDisplayName(String category) {
    switch (category) {
      case keterlambatan:
        return 'Keterlambatan';
      case fasilitasRusak:
        return 'Fasilitas Rusak';
      case pengemudiBermasalah:
        return 'Pengemudi Bermasalah';
      case lainnya:
        return 'Lainnya';
      default:
        return category;
    }
  }
}

// Report Status Constants
class ReportStatus {
  static const String pending = 'PENDING';
  static const String diproses = 'DIPROSES';
  static const String selesai = 'SELESAI';

  static List<String> get all => [pending, diproses, selesai];

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'Pending';
      case diproses:
        return 'Diproses';
      case selesai:
        return 'Selesai';
      default:
        return status;
    }
  }
}
