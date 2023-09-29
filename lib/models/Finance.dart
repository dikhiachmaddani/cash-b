// ignore_for_file: file_names

class Finance {
  int? id;
  String? type;
  DateTime? date;
  double? nominal;
  String? desc;

  Finance({this.type, this.date, this.nominal, this.desc});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'type': type,
      'date': date?.millisecondsSinceEpoch,
      'nominal': nominal,
      'desc': desc,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Finance.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type = map['type'];
    date = DateTime.fromMillisecondsSinceEpoch(map['date']);
    nominal = map['nominal'];
    desc = map['desc'];
  }
}