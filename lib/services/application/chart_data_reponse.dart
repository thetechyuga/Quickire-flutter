class ChartDataResponse {
  final List<int> applicationCounts; // List of application counts for each day
  final List<String> dates;

  ChartDataResponse({required this.applicationCounts, required this.dates});
}
