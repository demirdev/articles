import 'dart:convert';
import 'dart:io';

import 'country.dart';

void main() {
  final countriesAsMap =
      jsonDecode(File('countries.json').readAsStringSync()) as List<dynamic>;
  final countriesListAsDartString = 'const countries = ${'''[
    ${countriesAsMap.map((country) => Country.fromJson(country).toDartString()).join(',\n')}
]'''};';

  File('generated_country_list.dart')
      .writeAsStringSync('''import 'country.dart';

$countriesListAsDartString''');
}
