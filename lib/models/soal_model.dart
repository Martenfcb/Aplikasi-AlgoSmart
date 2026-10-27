class SoalModel {
  final String pertanyaan;
  final String pilihanA;
  final String pilihanB;
  final String pilihanC;
  final String pilihanD;
  final String jawaban;

  SoalModel({
    required this.pertanyaan,
    required this.pilihanA,
    required this.pilihanB,
    required this.pilihanC,
    required this.pilihanD,
    required this.jawaban,
  });

  Map<String, dynamic> toMap() {
    return {
      "pertanyaan": pertanyaan,
      "pilihanA": pilihanA,
      "pilihanB": pilihanB,
      "pilihanC": pilihanC,
      "pilihanD": pilihanD,
      "jawaban": jawaban,
    };
  }

  factory SoalModel.fromMap(
      Map<String, dynamic> map) {
    return SoalModel(
      pertanyaan: map["pertanyaan"] ?? "",
      pilihanA: map["pilihanA"] ?? "",
      pilihanB: map["pilihanB"] ?? "",
      pilihanC: map["pilihanC"] ?? "",
      pilihanD: map["pilihanD"] ?? "",
      jawaban: map["jawaban"] ?? "A",
    );
  }
}