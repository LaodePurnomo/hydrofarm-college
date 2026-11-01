// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hydrofarm/models/m_tanaman.dart';
import 'package:hydrofarm/services/tanaman_services.dart';
import 'package:hydrofarm/theme/app_colors.dart';

class TanamanInsert extends StatefulWidget {
  final Tanaman? tanaman;

  const TanamanInsert({super.key, this.tanaman});

  @override
  State<TanamanInsert> createState() => _TanamanInsertState();
}

class _TanamanInsertState extends State<TanamanInsert> {
  bool isSaving = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController jenisController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController umurPanenController = TextEditingController();

  String status = 'Aktif';

  @override
  void initState() {
    super.initState();

    if (widget.tanaman != null) {
      namaController.text = widget.tanaman!.namaTanaman;
      jenisController.text = widget.tanaman!.jenisTanaman;
      tanggalController.text = widget.tanaman!.tanggalTanam;
      umurPanenController.text = widget.tanaman!.umurPanen.toString();
      status = widget.tanaman!.status;
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    jenisController.dispose();
    tanggalController.dispose();
    umurPanenController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan atau mengupdate tanaman ke Google Sheets
  Future<void> simpanTanaman() async {
    if (!_formKey.currentState!.validate()) return;
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      final tanamanData = Tanaman(
        idTanaman: widget.tanaman?.idTanaman ?? '',
        namaTanaman: namaController.text.trim(),
        jenisTanaman: jenisController.text.trim(),
        tanggalTanam: tanggalController.text.trim(),
        umurPanen: int.parse(umurPanenController.text.trim()),
        status: status,
      );

      if (widget.tanaman == null) {
        // Mode Tambah
        await TanamanService.insertTanaman(tanamanData);
      } else {
        // Mode Edit
        await TanamanService.updateTanaman(tanamanData);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
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
              width: 38,
              height: 38,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Text(
              widget.tanaman == null ? 'Tambah Tanaman' : 'Edit Tanaman',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF0B6B72),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Tanaman',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tanaman harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: jenisController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Tanaman',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jenis tanaman harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Tanam',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tanam harus dipilih';
                  }
                  return null;
                },
                onTap: () async {
                  final DateTime? tanggalDipilih = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  );

                  if (tanggalDipilih != null) {
                    final String tanggalFormat =
                        '${tanggalDipilih.day.toString().padLeft(2, '0')}/'
                        '${tanggalDipilih.month.toString().padLeft(2, '0')}/'
                        '${tanggalDipilih.year}';

                    setState(() {
                      tanggalController.text = tanggalFormat;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: umurPanenController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Umur Panen',
                  hintText: 'Dalam hari',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final umur = int.tryParse(value ?? '');
                  if (umur == null || umur <= 0) {
                    return 'Masukkan umur panen berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Aktif',
                    child: Text('Aktif'),
                  ),
                  DropdownMenuItem(
                    value: 'Panen',
                    child: Text('Panen'),
                  ),
                  DropdownMenuItem(
                    value: 'Gagal',
                    child: Text('Gagal'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: isSaving ? null : simpanTanaman,
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
