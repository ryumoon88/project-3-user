// ignore_for_file: file_names

class Info {
  final String name;
  final String value;

  Info({required this.name, required this.value});

  Info fromJson(Map<String, dynamic> json) {
    var name = json['name'];
    var value = json['value'];
    return Info(name: name, value: value);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['value'] = value;
    return json;
  }
}
