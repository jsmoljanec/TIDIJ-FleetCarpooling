import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddVehicleManuallyForm extends StatefulWidget {
  @override
  _AddVehicleManuallyForm createState() => _AddVehicleManuallyForm();
}

class _AddVehicleManuallyForm extends State<AddVehicleManuallyForm> {
  final TextEditingController vinController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController fuelConsumptionController =
      TextEditingController();
  final List<String> capacity = ['1', '2', '3', '4', '5', '6', '7'];
  final List<String> transmissionType = ['Automatic', 'Manual'];
  String? selectedCapacity;
  String? selectedTransType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.mainTextColor),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            Text("ADD NEW CAR MANUALLY",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 25.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "VIN",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                )),
            const SizedBox(height: 3.0),
            MyTextField(controller: vinController),
            const SizedBox(height: 10),
            const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Model",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                )),
            const SizedBox(height: 3.0),
            MyTextField(controller: modelController),
            const SizedBox(height: 10),
            const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Brand",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                )),
            const SizedBox(height: 3.0),
            MyTextField(controller: brandController),
            const SizedBox(height: 20),
            const Row(children: [
              Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Capacity",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 100.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Transmission type",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  )),
            ]),
            SizedBox(height: 3.0),
            Row(
              children: [
                SizedBox(width: 24),
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.buttonColor, width: 1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                      items: capacity
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.mainTextColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedCapacity,
                      onChanged: (value) {
                        setState(() {
                          selectedCapacity = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        iconSize: 20,
                        iconEnabledColor: AppColors.buttonColor,
                        iconDisabledColor: Colors.grey,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.buttonColor, width: 1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                      items: transmissionType
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.mainTextColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedTransType,
                      onChanged: (value) {
                        setState(() {
                          selectedTransType = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        iconSize: 20,
                        iconEnabledColor: AppColors.buttonColor,
                        iconDisabledColor: Colors.grey,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(children: [
              Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Year",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 130.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Fuel consumption",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  )),
            ]),
            SizedBox(height: 3.0),
            Row(
              children: [
                Container(
                    width: 160, child: MyTextField(controller: yearController)),
                Container(
                    width: 245,
                    child: MyTextField(controller: fuelConsumptionController)),
              ],
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Registration",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                )),
            SizedBox(height: 3.0),
            Row(
              children: [
                Container(
                    width: 300,
                    padding: EdgeInsets.only(left: 0.0),
                    child: MyTextField(controller: registrationController)),
              ],
            ),
            SizedBox(height: 40.0),
            MyElevatedButton(
              onPressed: () {},
              label: 'ADD NEW CAR',
            )
          ],
        ),
      ),
    );
  }
}
