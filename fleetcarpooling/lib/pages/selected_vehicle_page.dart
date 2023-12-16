import 'package:fleetcarpooling/Models/terms_model.dart';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';
import 'package:fleetcarpooling/ReservationService/terms_service.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/calendar.dart';
import 'package:flutter/material.dart';

class SelectedVehiclePage extends StatefulWidget {
  final String vin;

  const SelectedVehiclePage({Key? key, required this.vin}) : super(key: key);

  @override
  State<SelectedVehiclePage> createState() => _SelectedVehiclePageState();
}

class _SelectedVehiclePageState extends State<SelectedVehiclePage> {
  late ReservationService _service = ReservationService();
  final TermsService _termsService = TermsService();
  late List<Terms> termini;
  late List<DateTime> busyTerms;
  late List<DateTime> freeTerms;

  @override
  void initState() {
    super.initState();
    _service = ReservationService();
    termini = [];
    busyTerms = [];
    freeTerms = [];

    _loadData();
  }

  void _loadData() {
    List<DateTime> workHours = _termsService.createWorkHours(
        DateTime.now(), DateTime.now().add(Duration(days: 365)));

    _service.getReservationStream(widget.vin).listen((newTermini) {
      termini = newTermini;
      busyTerms = _termsService.extractReservedTerms(termini);

      freeTerms =
          workHours.where((termin) => !busyTerms.contains(termin)).toList();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                CircularIconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(widget.vin),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset("assets/icons/chat.png"),
                  ),
                ),
              ],
            ),
          ),
          MyCalendar(
            height: 200,
            width: 300,
            busyTerms: busyTerms,
            freeTerms: freeTerms,
          ),
        ],
      ),
    );
  }
}
