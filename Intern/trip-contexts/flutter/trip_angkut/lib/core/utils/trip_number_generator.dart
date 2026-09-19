import '../constants/app_constants.dart';

class TripNumberGenerator {
  // Generate nomor trip: TRP-DDMMYY-SEQ
  // Contoh: TRP-120524-001 (Trip tanggal 12 Mei 2024, urutan pertama)
  static String generate(int sequence) {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString().substring(2);
    final seq = sequence.toString().padLeft(3, '0');
    return 'TRP-$day$month$year-$seq';
  }

  // Parse nomor trip ke komponen
  static TripNumberComponents? parse(String tripNumber) {
    final regex = RegExp(r'^TRP-(\d{2})(\d{2})(\d{2})-(\d{3})$');
    final match = regex.firstMatch(tripNumber);

    if (match == null) return null;

    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!) + 2000;
    final sequence = int.parse(match.group(4)!);

    return TripNumberComponents(
      day: day,
      month: month,
      year: year,
      sequence: sequence,
      full: tripNumber,
    );
  }

  // Validasi format nomor trip
  static bool isValidFormat(String tripNumber) {
    return parse(tripNumber) != null;
  }

  // Format tanggal dari nomor trip
  static String formatDate(String tripNumber) {
    final components = parse(tripNumber);
    if (components == null) return tripNumber;

    return '${components.day.toString().padLeft(2, '0')}/'
        '${components.month.toString().padLeft(2, '0')}/'
        '${components.year}';
  }
}

class TripNumberComponents {
  final int day;
  final int month;
  final int year;
  final int sequence;
  final String full;

  TripNumberComponents({
    required this.day,
    required this.month,
    required this.year,
    required this.sequence,
    required this.full,
  });

  @override
  String toString() => full;
}