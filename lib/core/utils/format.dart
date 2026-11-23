/// Formats an amount in tenge the way the design shows it: `12 400 ₸`.
/// Uses non-breaking spaces so a price never wraps.
String formatTenge(int amount) => '${formatThousands(amount)} ₸';

/// `1250` → `1 250`.
String formatThousands(int value) {
  final digits = value.abs().toString();
  final buf = StringBuffer(value < 0 ? '−' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(' ');
    buf.write(digits[i]);
  }
  return buf.toString();
}

/// `750` → `750 г`, `1200` → `1,2 кг`.
String formatWeight(int grams) {
  if (grams < 1000) return '$grams г';
  final kg = grams / 1000;
  final text = kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toStringAsFixed(1).replaceAll('.', ',');
  return '$text кг';
}

/// `+77071234567` → `+7 707 123 45 67`.
String formatPhone(String digits) {
  final d = digits.replaceAll(RegExp(r'\D'), '');
  final local = d.startsWith('7') && d.length == 11 ? d.substring(1) : d;
  final parts = <String>[];
  var i = 0;
  for (final len in [3, 3, 2, 2]) {
    if (i >= local.length) break;
    final end = (i + len).clamp(0, local.length);
    parts.add(local.substring(i, end));
    i = end;
  }
  return '+7 ${parts.join(' ')}'.trimRight();
}
