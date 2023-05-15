

class DiaryEntry{
  final String date;
  final String cont;

  const DiaryEntry({required this.cont, required this.date } );

  factory DiaryEntry.fromJson(Map<String, dynamic> json){
    return DiaryEntry(
        date: json['date'] as String,
        cont: json['cont'] as String,
    );
  }
}