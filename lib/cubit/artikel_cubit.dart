import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/article.dart';
import 'artikel_state.dart';

class ArtikelCubit extends Cubit<ArtikelState> {
  ArtikelCubit() : super(ArtikelInitial());

  // Dummy data untuk artikel
  final List<Article> _dummyArticles = [
    Article(
      id: '1',
      title: 'Tarif Baru Angkot 2024',
      content: '''
Pemerintah Kota Bandung telah menetapkan tarif baru angkot untuk tahun 2024. 
Tarif minimum angkot naik dari Rp 4.000 menjadi Rp 5.000 per penumpang. 
Kenaikan ini berlaku untuk seluruh trayek angkot di wilayah Bandung Raya.

Alasan kenaikan tarif:
- Kenaikan harga BBM
- Biaya operasional yang meningkat
- Perawatan kendaraan

Penetapan tarif ini sudah melalui musyawarah antara pemerintah, ORGANDA, 
dan perwakilan pengemudi angkot. Diharapkan dengan tarif baru ini, 
pelayanan angkot dapat lebih baik dan armada lebih terawat.
      ''',
      category: 'INFO',
      imageUrl: 'https://via.placeholder.com/400x200?text=Tarif+Angkot',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Article(
      id: '2',
      title: 'Rute Baru Angkot K7 Dibuka',
      content: '''
Dishub Kota Bandung membuka rute baru angkot K7 yang menghubungkan 
Terminal Leuwipanjang dengan kawasan Gedebage. Rute ini diharapkan 
dapat memudahkan akses warga menuju kawasan industri dan perdagangan.

Detail Rute K7:
- Berangkat: Terminal Leuwipanjang
- Melalui: Jl. Soekarno-Hatta, Jl. Gedebage
- Tujuan: Kawasan Industri Gedebage
- Jam operasional: 05:00 - 20:00 WIB
- Tarif: Rp 5.000

Armada yang digunakan adalah 20 unit angkot dengan kondisi prima 
dan dilengkapi AC untuk kenyamanan penumpang.
      ''',
      category: 'INFO',
      imageUrl: 'https://via.placeholder.com/400x200?text=Rute+Baru+K7',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Article(
      id: '3',
      title: 'Tips Aman Naik Angkutan Umum',
      content: '''
Keamanan dan kenyamanan adalah prioritas saat menggunakan angkutan umum. 
Berikut tips yang perlu diperhatikan:

1. Jaga Barang Bawaan
   - Selalu pegang tas di depan badan
   - Jangan letakkan HP di saku belakang
   - Waspadai barang berharga

2. Pilih Tempat Duduk yang Aman
   - Duduk di dekat pengemudi jika sendirian
   - Hindari duduk paling belakang saat sepi
   - Pilih kursi yang dekat dengan pintu

3. Perhatikan Lingkungan
   - Waspadai orang mencurigakan
   - Jangan tertidur saat perjalanan
   - Simpan nomor darurat

4. Bayar Sesuai Tarif
   - Siapkan uang pas
   - Minta struk jika tersedia
   - Jangan lupa ambil kembalian

5. Etika di Angkot
   - Berikan tempat untuk lansia/ibu hamil
   - Jangan makan/minum
   - Berbicara dengan suara wajar

Dengan menerapkan tips ini, perjalanan Anda akan lebih aman dan nyaman.
      ''',
      category: 'EDUKASI',
      imageUrl: 'https://via.placeholder.com/400x200?text=Tips+Aman',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  void loadArticles() {
    try {
      emit(ArtikelLoading());
      // Simulasi loading
      Future.delayed(const Duration(milliseconds: 500), () {
        emit(ArtikelLoaded(List.from(_dummyArticles)));
      });
    } catch (e) {
      emit(ArtikelError('Gagal memuat artikel: ${e.toString()}'));
    }
  }

  void addArticle(Article article) {
    final currentState = state;
    if (currentState is ArtikelLoaded) {
      final updatedArticles = List<Article>.from(currentState.articles)
        ..insert(0, article);
      emit(ArtikelLoaded(updatedArticles));
    }
  }

  void deleteArticle(String articleId) {
    final currentState = state;
    if (currentState is ArtikelLoaded) {
      final updatedArticles = currentState.articles
          .where((article) => article.id != articleId)
          .toList();
      emit(ArtikelLoaded(updatedArticles));
    }
  }

  void updateArticle(Article updatedArticle) {
    final currentState = state;
    if (currentState is ArtikelLoaded) {
      final updatedArticles = currentState.articles.map((article) {
        return article.id == updatedArticle.id ? updatedArticle : article;
      }).toList();
      emit(ArtikelLoaded(updatedArticles));
    }
  }

  List<Article> getArticlesByCategory(String category) {
    final currentState = state;
    if (currentState is ArtikelLoaded) {
      return currentState.articles
          .where((article) => article.category == category)
          .toList();
    }
    return [];
  }

  Article? getArticleById(String id) {
    final currentState = state;
    if (currentState is ArtikelLoaded) {
      try {
        return currentState.articles.firstWhere((article) => article.id == id);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
