class Tanaman {
  final String idTanaman;
  final String namaTanaman;
  final String jenisTanaman;
  final String tanggalTanam;
  final int umurPanen;
  final String status;

  Tanaman({
    required this.idTanaman,
    required this.namaTanaman,
    required this.jenisTanaman,
    required this.tanggalTanam,
    required this.umurPanen,
    required this.status,
  });

  factory Tanaman.fromJson(Map<String, dynamic> json) {
    return Tanaman(
      idTanaman: json['id_tanaman'].toString(),
      namaTanaman: json['nama_tanaman'].toString(),
      jenisTanaman: json['jenis_tanaman'].toString(),
      tanggalTanam: json['tanggal_tanam'].toString(),
      umurPanen: int.tryParse(
            json['umur_panen'].toString(),
          ) ??
          0,
      status: json['status'].toString(),
    );
  }
}
