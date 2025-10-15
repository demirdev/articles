class Country {
  final String name;
  final String flag;
  final String code;
  final String dialCode;

  const Country(
      {required this.name,
      required this.flag,
      required this.code,
      required this.dialCode});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      flag: json['flag'],
      code: json['code'],
      dialCode: json['dial_code'],
    );
  }

  toDartString() {
    return '''Country(
    name: "$name",
    flag: "$flag",
    code: "$code",
    dialCode: "$dialCode",
  )''';
  }
}
