// import 'dart:js';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hydrofarm/screens/tanaman_detail.dart';
import 'package:hydrofarm/screens/tanaman_insert.dart';
import 'package:hydrofarm/services/tanaman_services.dart';
import 'package:hydrofarm/theme/app_colors.dart';

import '../models/m_tanaman.dart';

class TanamanScreen extends StatefulWidget {
  TanamanScreen({super.key});

  @override
  State<TanamanScreen> createState() => _TanamanScreenState();
}

class _TanamanScreenState extends State<TanamanScreen> {
  List<Tanaman> daftarTanaman = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> loadTanaman() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await TanamanService.getTanaman();
      if (!mounted) return;
      setState(() {
        daftarTanaman = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
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
            const Text(
              'Data Tanaman',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF0B6B72),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(errorMessage!, textAlign: TextAlign.center),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async => await loadTanaman(),
                          child: Text('Coba Lagi!'),
                        ),
                      ],
                    ),
                  ),
                )
              : daftarTanaman.isEmpty
                  ? Center(child: Text('Belum Ada Data Tanaman'))
                  : ListView.builder(
                      itemCount: daftarTanaman.length,
                      itemBuilder: (context, index) {
                        final tanaman = daftarTanaman[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.eco, color: Colors.green),
                            title: Text(tanaman.namaTanaman),
                            subtitle: Text(tanaman.jenisTanaman),
                            trailing: Text(tanaman.status),
                            onTap: () async {
                              final hasil = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TanamanDetail(tanaman: tanaman),
                                ),
                              );

                              // Update (Kode baru pengganti yang lama)
                              if (!mounted) return;
                              if (hasil == true) {
                                await loadTanaman();
                              }
                            },
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TanamanInsert(),
            ),
          );
          if (!mounted) return;
          if (hasil == true) {
            await loadTanaman();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadTanaman();
  }
}
