
// import 'package:json_annotation/json_annotation.dart';
// part 'user.g.dart';
//
// @JsonSerializable()
class DiaryEntry{
  final String date;
  final List<Sip>? sips;

  const DiaryEntry({this.sips, required this.date } );

  factory DiaryEntry.fromJson(Map<String, dynamic> json){
    return DiaryEntry(
        date: json['date'] as String,
        sips: (json['sips'] as List).map((e) => Sip.fromJson(e)).toList(),
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date,
        'sips': sips!.map((e) {
          Sip sip = Sip(time: e.time, amount: e.amount);
          return sip.toJson();
        }).toList(),
      };

}


class Sip{
  final String time;
  final int amount;

  const Sip({required this.time, required this.amount});

  //factory Sip.fromJson(Map<String, dynamic> json){ _$SipFromJson(json); }

  factory Sip.fromJson(Map<String, dynamic> json){
    return Sip(
      time: json['time'],
      amount: json['amount'],
    );
  }
  Map<String, dynamic> toJson() => {
    'time': time,
    'amount': amount,
  };


}