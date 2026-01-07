import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/guide.dart';
import 'panduan_state.dart';

class PanduanCubit extends Cubit<PanduanState> {
  PanduanCubit() : super(PanduanInitial());

  // Dummy data untuk panduan
  final List<Guide> _dummyGuides = [
    Guide(
      id: '1',
      title: 'Cara Mencari Rute Angkot',
      description: '''
Untuk mencari rute angkot yang tepat, ikuti langkah berikut:

1. Buka menu "Info Trayek" di bagian bawah aplikasi
2. Gunakan fitur pencarian untuk memasukkan lokasi tujuan Anda
3. Aplikasi akan menampilkan daftar rute angkot yang tersedia
4. Pilih rute yang sesuai dengan kebutuhan Anda
5. Lihat detail rute termasuk jalur yang dilalui dan jam operasional
6. Anda bisa menambahkan rute favorit dengan menekan tombol bintang

Tips:
- Cek jam operasional sebelum berangkat
- Perhatikan pemberhentian utama di sepanjang rute
- Simpan rute yang sering Anda gunakan sebagai favorit
      ''',
      icon: Icons.map,
    ),
    Guide(
      id: '2',
      title: 'Cara Melaporkan Masalah',
      description: '''
Jika Anda menemukan masalah atau ingin memberikan masukan, 
gunakan fitur pelaporan dengan cara:

1. Klik tombol "Lapor" berwarna merah di pojok kanan bawah
2. Pilih kategori masalah:
   - Keterlambatan
   - Fasilitas Rusak
   - Pengemudi Bermasalah
   - Lainnya
3. Isi deskripsi masalah secara detail
4. Tambahkan foto pendukung jika diperlukan (opsional)
5. Klik "Kirim Laporan"
6. Laporan Anda akan diproses oleh admin

Anda bisa melihat status laporan di menu "Laporan Saya" 
pada halaman Akun & Riwayat.

Laporan Anda sangat membantu meningkatkan kualitas layanan!
      ''',
      icon: Icons.report_problem,
    ),
    Guide(
      id: '3',
      title: 'Cara Menggunakan Fitur GPS',
      description: '''
Fitur GPS membantu Anda melacak posisi angkot secara real-time:

1. Pastikan GPS di ponsel Anda aktif
2. Berikan izin lokasi ke aplikasi Ngangkot
3. Buka halaman "Beranda"
4. Lihat peta yang menampilkan:
   - Posisi Anda (titik biru)
   - Lokasi angkot terdekat (ikon kuning)
   - Rute angkot (garis di peta)

5. Tap pada ikon angkot untuk melihat informasi:
   - Nomor trayek
   - Estimasi waktu tiba
   - Arah tujuan

6. Anda juga bisa mengaktifkan pelacakan untuk mendapat 
   notifikasi saat angkot mendekati lokasi Anda

Catatan:
- Fitur ini memerlukan koneksi internet
- GPS menggunakan data lokasi secara real-time
- Akurasi tergantung sinyal GPS dan jaringan
      ''',
      icon: Icons.gps_fixed,
    ),
  ];

  void loadGuides() {
    try {
      emit(PanduanLoading());
      // Simulasi loading
      Future.delayed(const Duration(milliseconds: 500), () {
        emit(PanduanLoaded(List.from(_dummyGuides)));
      });
    } catch (e) {
      emit(PanduanError('Gagal memuat panduan: ${e.toString()}'));
    }
  }

  void addGuide(Guide guide) {
    final currentState = state;
    if (currentState is PanduanLoaded) {
      final updatedGuides = List<Guide>.from(currentState.guides)
        ..insert(0, guide);
      emit(PanduanLoaded(updatedGuides));
    }
  }

  void deleteGuide(String guideId) {
    final currentState = state;
    if (currentState is PanduanLoaded) {
      final updatedGuides =
          currentState.guides.where((guide) => guide.id != guideId).toList();
      emit(PanduanLoaded(updatedGuides));
    }
  }

  void updateGuide(Guide updatedGuide) {
    final currentState = state;
    if (currentState is PanduanLoaded) {
      final updatedGuides = currentState.guides.map((guide) {
        return guide.id == updatedGuide.id ? updatedGuide : guide;
      }).toList();
      emit(PanduanLoaded(updatedGuides));
    }
  }

  Guide? getGuideById(String id) {
    final currentState = state;
    if (currentState is PanduanLoaded) {
      try {
        return currentState.guides.firstWhere((guide) => guide.id == id);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
