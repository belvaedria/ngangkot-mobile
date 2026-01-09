import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/search_history_item.dart';

/// Academic-safe: in-memory only (no local storage / DB).
/// Keeps history & favorites during app runtime.
class HistoryCubit extends Cubit<List<SearchHistoryItem>> {
  HistoryCubit() : super(const []);

  /// Add a new search to history (most recent first).
  Future<void> addSearch({required String asal, required String tujuan}) async {
    final a = asal.trim();
    final t = tujuan.trim();
    if (a.isEmpty || t.isEmpty) return;

    final now = DateTime.now();

    // If already exists, bump to top and keep favorite flag.
    final existingIndex =
        state.indexWhere((e) => e.asal.toLowerCase() == a.toLowerCase() && e.tujuan.toLowerCase() == t.toLowerCase());

    final List<SearchHistoryItem> next = List.of(state);
    if (existingIndex >= 0) {
      final existing = next.removeAt(existingIndex);
      next.insert(
        0,
        SearchHistoryItem(
          asal: existing.asal,
          tujuan: existing.tujuan,
          createdAt: now,
          isFavorite: existing.isFavorite,
        ),
      );
    } else {
      next.insert(
        0,
        SearchHistoryItem(
          asal: a,
          tujuan: t,
          createdAt: now,
          isFavorite: false,
        ),
      );
    }

    // Optional: cap size
    const maxItems = 30;
    if (next.length > maxItems) next.removeRange(maxItems, next.length);

    emit(next);
  }

  void toggleFavorite(SearchHistoryItem item) {
    final List<SearchHistoryItem> next = state.map((e) {
      if (e.asal == item.asal && e.tujuan == item.tujuan && e.createdAt == item.createdAt) {
        return e.copyWith(isFavorite: !e.isFavorite);
      }
      // also toggle if same pair but different createdAt (safer UX)
      if (e.asal.toLowerCase() == item.asal.toLowerCase() && e.tujuan.toLowerCase() == item.tujuan.toLowerCase()) {
        return e.copyWith(isFavorite: !e.isFavorite);
      }
      return e;
    }).toList();

    // Keep favorites on top? The UI already groups, but we keep recency order.
    emit(next);
  }

  void removeItem(SearchHistoryItem item) {
    emit(state.where((e) => !(e.asal.toLowerCase() == item.asal.toLowerCase() && e.tujuan.toLowerCase() == item.tujuan.toLowerCase())).toList());
  }

  void clear() => emit(const []);
}
