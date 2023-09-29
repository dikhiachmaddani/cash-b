// ignore_for_file: file_names, unnecessary_this, prefer_collection_literals

class Users {
  int? id;
  String? username;
  String? password;

  Users({this.username, this.password});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['username'] = username;
    map['password'] = password;

    return map;
  }

  Users.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.username = map['username'];
    this.password = map['password'];
  }
}
