/// Text that comes from the backend in both app languages.
class LocalizedText {
  const LocalizedText(this.ru, this.kk);

  /// Same text in both languages (brand names, numbers).
  const LocalizedText.same(String text) : ru = text, kk = text;

  final String ru;
  final String kk;

  String resolve(String languageCode) => languageCode == 'kk' ? kk : ru;
}
