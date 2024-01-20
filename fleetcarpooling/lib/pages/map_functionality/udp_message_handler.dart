import 'package:core/ui_elements/custom_toast.dart';

class UDPMessageHandler {
  UDPMessageHandler();

  void handle(String message) {
    RegExp bracketsRegExp = RegExp(r'\[([^\]]*)\]');
    Iterable<RegExpMatch> matches = bracketsRegExp.allMatches(message);

    if (matches.isNotEmpty) {
      String flagContent = matches.elementAt(0).group(1) ?? '';
      String vehicleContent =
          matches.length > 1 ? matches.elementAt(1).group(1) ?? '' : '';
      String vehicleId = "[${vehicleContent.split('-')[0]}]";
      
      CustomToast().showStatusToast(message, flagContent, vehicleId);
    } else {
      CustomToast().showFlutterToast('Uglate zagrade nisu pronađene u tekstu.');
    }
  }

  void handleLocationMessage(String message) {
    RegExp regExp = RegExp(r"'latitude': (\d+\.\d+), 'longitude': (\d+\.\d+)");
    var match = regExp.firstMatch(message);
    if (match != null) {
      var latitude = double.parse(match.group(1)!);
      var longitude = double.parse(match.group(2)!);
      CustomToast().showFlutterToast('$latitude, $longitude');
    }
  }
}
