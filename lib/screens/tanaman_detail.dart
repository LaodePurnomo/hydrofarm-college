import 'package:flutter/material.dart';
import 'package:hydrofarm/screens/tanaman_insert.dart';
import 'package:hydrofarm/theme/app_colors.dart';

import '../models/m_tanaman.dart';
// 1. Mengimpor TanamanService
import '../services/tanaman_services.dart';

// 2. Mengubah menjadi StatefulWidget
class TanamanDetail extends StatefulWidget {
  final Tanaman tanaman;

  const TanamanDetail({super.key, required this.tanaman});

  @override
  State<TanamanDetail> createState() => _TanamanDetailState();
}

class _TanamanDetailState extends State<TanamanDetail> {
  // 3. Menambahkan variabel isDeleting
  bool isDeleting = false;

  // 4. Menambahkan fungsi hapusTanaman
  Future<void> hapusTanaman() async {
    if (isDeleting) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus '
          '${widget.tanaman.namaTanaman}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Ya, Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    setState(() {
      isDeleting = true;
    });

    try {
      await TanamanService.deleteTanaman(
        widget.tanaman.idTanaman,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Detail Tanaman',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B6B72),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Tombol Edit
          IconButton(
            tooltip: 'Edit Data',
            onPressed: () async {
              final hasil = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TanamanInsert(tanaman: widget.tanaman),
                ),
              );

              if (!mounted) return;
              if (hasil == true) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(
              Icons.edit,
              color: AppColors.primary,
            ),
          ),

          // 5. Memperbarui Tombol Hapus
          IconButton(
            onPressed: isDeleting ? null : hapusTanaman,
            icon: isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.delete_outline),
            color:
                Colors.red, // Saya asumsikan AppColors.error adalah Colors.red
            tooltip: 'Hapus Tanaman',
            iconSize: 26,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.eco,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              widget.tanaman.namaTanaman,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.tanaman.jenisTanaman,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    detailItem(
                      'ID Tanaman',
                      widget.tanaman.idTanaman,
                    ),
                    detailItem(
                      'Tanggal Tanam',
                      widget.tanaman.tanggalTanam,
                    ),
                    detailItem(
                      'Umur Panen',
                      '${widget.tanaman.umurPanen} Hari',
                    ),
                    detailItem(
                      'Status',
                      widget.tanaman.status,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
