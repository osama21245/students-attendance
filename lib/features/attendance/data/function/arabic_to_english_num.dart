String arabicToEnglish(String input) {
  Map<String, String> arabicToEnglishMap = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    '.': '.',
  };

  String englishNumber = '';
  for (int i = 0; i < input.length; i++) {
    String currentChar = input[i];
    if (arabicToEnglishMap.containsKey(currentChar)) {
      englishNumber += arabicToEnglishMap[currentChar]!;
    } else {
      englishNumber += currentChar;
    }
  }
  return englishNumber;
}
