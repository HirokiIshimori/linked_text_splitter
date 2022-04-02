enum Language {
  english,
  japanese,
  korean,
  spanish,
  arabic,
  thai,
  norwegian,
  german
}

extension LanguageEx on Language {
  String get letter {
    switch (this) {
      case Language.english: return 'a-zA-Zａ-ｚＡ-Ｚ.?/-';
      case Language.japanese: return 'ぁ-んァ-ン一-龠';
      case Language.korean: return '\u1100-\u11FF\uAC00-\uD7A3';
      case Language.spanish: return 'áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ';
      case Language.arabic: return '\u0621-\u064A';
      case Language.thai: return '\u0E00-\u0E7F';
      case Language.norwegian: return 'åøæ';
      case Language.german: return 'ÄäÖöÜüẞß';
    }
  }
}

const symbols = '·・ー_';
const numbers = '0-9０-９';
const httpRegExp = '(http://|https://){1}[\\w\\.\\-/:\\#\\?\\=\\&\\;\\%\\~\\+\$]+';