import '../Models/terms_model.dart';

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

  List<DateTime> extractReservedTerms(List<Terms> terms) {
    List<DateTime> reservedTerms = [];
    for (Terms t in terms) {
      for (int i = 0; i <= t.returnDate.difference(t.pickupDate).inDays; i++) {
        for (int j = (i == 0 ? t.pickupDate.hour : 7);
            j <=
                (i < t.returnDate.difference(t.pickupDate).inDays
                    ? 16
                    : t.returnDate.hour);
            j++) {
          reservedTerms.add(DateTime(
              t.pickupDate.year, t.pickupDate.month, t.pickupDate.day + i, j));
        }
      }
    }
    return reservedTerms;
  }
}
