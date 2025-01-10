String getTimeRemaining(DateTime endDate) {
  final now = DateTime.now();
  final difference = endDate.difference(now);

  final days = difference.inDays;
  final hours = difference.inHours % 24;

  return '$days días, $hours horas';
}
