// ignore_for_file: use_named_constants

import 'package:flutter_test/flutter_test.dart';
import 'package:hashed/domain-shared/user_input_number_formatter.dart';

void main() {
  final inputFormatter = UserInputNumberFormatter();

  test('Input: 45 should return 45', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "45");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "45");
  });

  test('Input: 8, should return 8', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "8");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "8");
  });

  test('Input: "", should return "" ', () async {
    final TextEditingValue userInput = const TextEditingValue();
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "");
  });

  test('Input: 69.9 should return 69.9', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "69.9");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "69.9");
  });

  test('Input: 69, should return 69.', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "69,");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "69.");
  });

  test('Input: 69.. should return 69.', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "69..");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "69.");
  });

  test('Input: 458,4 should return 458.4', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "458,4");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "458.4");
  });

  test('Input: 453,343,343.676, should return 453343343.676', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "453,343,343.676,");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "453343343.676");
  });

  test('Input: 453,343,343.676 should return 453343343.676 ', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "453,343,343.676");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "453343343.676");
  });

  test('Input: 453.343.343,676 should return 453343343.676 ', () async {
    final TextEditingValue userInput = const TextEditingValue(
      text: "453.343.343,676",
    );
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "453343343.676");
  });

  test('Input: 46..474,38493.3627,384 should return 46474384933627.384 ', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "46..474,38493.3627,384");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "46474384933627.384");
  });

  test('Input: "345,,,," , should return "345." ', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "345,,,,");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "345.");
  });

  test('Input: 8746..474,38493.3627,384 should return 8746474384933627.384', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "8746..474,38493.3627,384");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "8746474384933627.384");
  });

  test('Input: 843.384, should return 843.384', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "843.384,");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "843.384");
  });

  test('Input: 843.384. should return 843.384', () async {
    final TextEditingValue userInput = const TextEditingValue(text: "843.384.");
    final result = inputFormatter.formatEditUpdate(TextEditingValue.empty, userInput);
    expect(result.text, "843.384");
  });
}
