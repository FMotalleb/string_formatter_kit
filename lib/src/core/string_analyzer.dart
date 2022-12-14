import 'package:string_formatter_kit/src/core/regex_extension/regex_part.dart';

class StringAnalyzer {
  /// starting node of scanner
  final RegExRoot tokenRoot;

  /// internal regex generated from
  final RegExp _regex;

  StringAnalyzer({
    required this.tokenRoot,
  }) : _regex = tokenRoot.regex;

  /// checking if has can match anything in given [source]
  bool canParse(String source) => _regex.allMatches(source).isNotEmpty;

  /// cast string to objects
  Iterable<Map<String, String?>> readAllToMap(String source) sync* {
    final matchResult = _regex.allMatches(source);
    for (final i in matchResult) {
      final result = i.groupNames.map((e) => MapEntry(e, i.namedGroup(e)));
      yield Map.fromEntries(
        result,
      );
    }
  }

  /// cast string to object
  Map<String, String?> readToMap(
    String source,
  ) {
    final matchResult = _regex.allMatches(source);
    if (matchResult.isEmpty) {
      return {};
    }
    final match = matchResult.first;
    final result = match.groupNames.map(
      (e) => MapEntry(
        e,
        match.namedGroup(e),
      ),
    );
    return Map.fromEntries(
      result,
    );
  }

  /// format source to string
  /// [source] should be map or at least contain [toMap] method
  String format<T extends dynamic>(T source) {
    if (source == null) {
      throw Exception('null input for format is not allowed');
    }
    if (source is Map) {
      final casted = source.map(
        (key, value) => MapEntry(
          key.toString(),
          value.toString(),
        ),
      );
      return tokenRoot.fillWith(casted);
    } else {
      return format<Map<String, dynamic>>(source.toMap());
    }
  }
}
