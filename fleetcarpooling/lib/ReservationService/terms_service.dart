class TermsService {
  List<DateTime> createWorkHours(DateTime start, DateTime end) {
    List<DateTime> radniSati = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      for (int j = 7; j <= 16; j++) {
        radniSati.add(DateTime(start.year, start.month, start.day + i, j));
      }
    }
    return radniSati;
  }
}
