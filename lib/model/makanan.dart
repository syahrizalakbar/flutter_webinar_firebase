import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

Makanan makananFromJson(String str) => Makanan.fromJson(json.decode(str));

String makananToJson(Makanan data) => json.encode(data.toJson());

class Makanan {
  Makanan({
    this.key,
    this.nama,
    this.rating,
    this.harga,
  });

  String key;
  String nama;
  int rating;
  int harga;

  factory Makanan.fromJson(Map<String, dynamic> json) => Makanan(
    nama: json["nama"] == null ? null : json["nama"],
    rating: json["rating"] == null ? null : json["rating"],
    harga: json["harga"] == null ? null : json["harga"],
  );

  factory Makanan.fromSnapshot(DataSnapshot snapshot) => Makanan(
    key: snapshot.key,
    nama: snapshot.value["nama"] == null ? null : snapshot.value["nama"],
    rating: snapshot.value["rating"] == null ? null : snapshot.value["rating"],
    harga: snapshot.value["harga"] == null ? null : snapshot.value["harga"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama == null ? null : nama,
    "rating": rating == null ? null : rating,
    "harga": harga == null ? null : harga,
  };
}
