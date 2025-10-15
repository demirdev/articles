# Stop Parsing static JSON at Runtime in Your Flutter Apps

## The Problem with Runtime JSON Parsing

Imagine this: You're building a Flutter app that displays countries with their codes and flags. You bundle a `countries.json` file and parse it every time the app starts:

1. Read the JSON file from assets
2. Parse it with `jsonDecode()`
3. Convert it to Dart objects using `fromJson()`

```dart
// ❌ The inefficient way
Future<List<Country>> loadCountries() async {
  final jsonString = await rootBundle.loadString('assets/countries.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Country.fromJson(json)).toList();
}
```

**The problem?** Parsing static JSON at runtime wastes CPU cycles, adds startup latency, and drains battery.

## The Solution: Development-Time Code Generation

Convert JSON to Dart code **once** during development — resulting in a `const` list compiled into your binary with zero runtime overhead!

### Step 1: Create Your Model

  Create a `Country` model with a const constructor and a `toDartString()` method:

```dart
// country.dart
class Country {
  final String name;
  final String flag;
  final String code;
  final String dialCode;

  const Country({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      flag: json['flag'],
      code: json['code'],
      dialCode: json['dial_code'],
    );
  }

  // This method generates Dart source code!
  String toDartString() {
    return '''
  Country(
    name: "$name",
    flag: "$flag",
    code: "$code",
    dialCode: "$dialCode",
  )''';
  }
}
```

The key here is the `toDartString()` method — it generates the Dart source code representation of the object.

### Step 2: Build Your Generator Script

Create a simple Dart script that reads your JSON and outputs Dart code:

```dart
// main.dart
import 'dart:convert';
import 'dart:io';
import 'country.dart';

void main() {
  // Read and parse the JSON
  final countriesAsMap = jsonDecode(
    File('countries.json').readAsStringSync()
  ) as List<dynamic>;
  
  // Generate Dart source code by mapping each JSON object to its Dart representation
  final countriesListAsDartString = 'const countries = ${'''
[
  ${countriesAsMap.map((country) => Country.fromJson(country).toDartString()).join(',\n')}
]
'''};';
  
  // Write it to a .dart file
  File('generated_country_list.dart').writeAsStringSync('''
import 'country.dart';

$countriesListAsDartString
''');
}
```

### Step 3: Run the Generator

```bash
dart main.dart
```

This generates a `generated_country_list.dart` file:

```dart
// generated_country_list.dart (generated)
import 'country.dart';

const countries = [
  Country(
    name: "Afghanistan",
    flag: "🇦🇫",
    code: "AF",
    dialCode: "+93",
  ),
  Country(
    name: "Åland Islands",
    flag: "🇦🇽",
    code: "AX",
    dialCode: "+358",
  ),
  Country(
    name: "Albania",
    flag: "🇦🇱",
    code: "AL",
    dialCode: "+355",
  ),
  // ... rest of your countries
];
```

### Step 4: Use It in Your App

Now in your Flutter app, just import and use the const list directly:

```dart
import 'generated_country_list.dart';

// ✅ Zero runtime overhead!
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: countries.length,
    itemBuilder: (context, index) {
      final country = countries[index];
      return ListTile(
        leading: Text(country.flag, style: TextStyle(fontSize: 32)),
        title: Text(country.name),
        subtitle: Text('${country.code} ${country.dialCode}'),
      );
    },
  );
}
```

## Benefits of This Approach

✅ **Faster App Startup** — No JSON parsing means your app launches faster

✅ **Lower Memory Usage** — Const objects are more memory-efficient

✅ **No Asset Loading** — No need to bundle JSON files or use `rootBundle.loadString()`

## When to Use This Pattern

This approach works great for:
- Static reference data (countries, currencies, time zones, etc.)
- Lists that rarely change

**When NOT to use it:**
- Data that changes frequently
- User-generated content
- Data fetched from APIs
- Large datasets (>10MB) that would bloat your app size

## Conclusion

Move JSON parsing from runtime to development time. Eliminate unnecessary overhead. Ship faster, more efficient apps.

The code stays simple and maintainable. Get JSON convenience during development. Get const performance in production.

Next time you bundle static JSON, ask yourself: "Could this be a const list instead?"

---

## Running the Example

```bash
# Clone only this article (sparse checkout)
git clone --filter=blob:none --sparse https://github.com/demirdev/articles
cd articles
git config core.sparseCheckout true
git sparse-checkout init
git sparse-checkout set 01-json-to-dart-list

# Or download the folder directly from GitHub

# Run the generator
cd 01-json-to-dart-list
dart run main.dart
```

---

**Follow me on:**
- 📝 [Github](https://github.com/demirdev)
- 📝 [Medium](https://medium.com/@demirdev)
- 📝 [X/Twitter](https://x.com/demirdevv)

