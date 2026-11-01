import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/m_tanaman.dart';

class TanamanService {
  static const String apiUrl =
      'https://script.google.com/macros/s/AKfycbyV9O1Lda9XwUTiDPAWKZ3DWvA2zz1WNKym3hlYn28xY71Ec1wE4kSKq5VeoD-FmrCR/exec';

  // Mengambil data tanaman dari Google Sheets
  static Future<List<Tanaman>> getTanaman() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data. HTTP ${response.statusCode}',
      );
    }

    final Map<String, dynamic> hasil = jsonDecode(response.body);

    if (hasil['success'] != true) {
      throw Exception(
        hasil['message'] ?? 'Gagal mengambil data tanaman',
      );
    }

    final List<dynamic> data = hasil['data'];

    return data.map((item) => Tanaman.fromJson(item)).toList();
  }

  // Menambahkan data tanaman ke Google Sheets
  static Future<void> insertTanaman(Tanaman tanaman) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'insert',
        'nama_tanaman': tanaman.namaTanaman,
        'jenis_tanaman': tanaman.jenisTanaman,
        'tanggal_tanam': tanaman.tanggalTanam,
        'umur_panen': tanaman.umurPanen,
        'status': tanaman.status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal menyimpan tanaman. HTTP ${response.statusCode}',
      );
    }

    final hasil = jsonDecode(response.body);

    if (hasil['success'] != true) {
      throw Exception(
        hasil['message'] ?? 'Gagal menyimpan tanaman',
      );
    }
  }

  // Memperbarui data tanaman di Google Sheets
  static Future<void> updateTanaman(Tanaman tanaman) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'update',
        'id_tanaman': tanaman.idTanaman,
        'nama_tanaman': tanaman.namaTanaman,
        'jenis_tanaman': tanaman.jenisTanaman,
        'tanggal_tanam': tanaman.tanggalTanam,
        'umur_panen': tanaman.umurPanen,
        'status': tanaman.status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memperbarui tanaman. HTTP ${response.statusCode}',
      );
    }

    final Map<String, dynamic> hasil = jsonDecode(response.body);

    if (hasil['success'] != true) {
      throw Exception(
        hasil['message'] ?? 'Gagal memperbarui tanaman',
      );
    }
  }

  // Menghapus data tanaman di Google Sheets
  static Future<void> deleteTanaman(String idTanaman) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'delete',
        'id_tanaman': idTanaman,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal menghapus tanaman. HTTP ${response.statusCode}',
      );
    }

    final Map<String, dynamic> hasil = jsonDecode(response.body);

    if (hasil['success'] != true) {
      throw Exception(
        hasil['message'] ?? 'Gagal menghapus tanaman',
      );
    }
  }
}
