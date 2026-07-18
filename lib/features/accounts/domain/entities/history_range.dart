/// History window for the balance chart. [days] doubles as the API query
/// parameter and the cache key, so a cached window is exactly one request.
enum HistoryRange {
  month(days: 30),
  quarter(days: 90),
  year(days: 365);

  const HistoryRange({required this.days});

  final int days;
}
