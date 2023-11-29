import 'package:fleetcarpooling/Modularity/service/image_service.dart';
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
  String? imageUrlCar;
  bool isImageUploaded = false;
  final List<String> capacity = ['1', '2', '3', '4', '5', '6', '7'];
  final UploadImage _repository = new UploadImage();
  final List<String> transmissionType = ['Automatic', 'Manual'];
  String? selectedCapacity;
  String? selectedTransType;
  String? selectedYear;
  List<String> generateYearsList() {
    int currentYear = DateTime.now().year;
    List<String> yearsList = [];
    for (int year = 2012; year <= currentYear; year++) {
      yearsList.add(year.toString());
    }
    return yearsList;
  }

  @override
  Widget build(BuildContext context) {
    List<String> years = generateYearsList();
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
                    TextStyle(color: AppColors.mainTextColor, fontSize: 18.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                ),
              ),
              const SizedBox(height: 3.0),
              Container(
                height: 43,
                child: MyTextField(controller: vinController),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Model",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              Container(
                height: 43,
                child: MyTextField(controller: modelController),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Brand",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              Container(
                height: 43,
                child: MyTextField(controller: brandController),
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Capacity",
                            style: TextStyle(color: AppColors.mainTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Transmission type",
                          style: TextStyle(color: AppColors.mainTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.buttonColor, width: 1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: capacity
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
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
                                  height: 43,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.buttonColor, width: 1),
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
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "Year",
                              style: TextStyle(color: AppColors.mainTextColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  const Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Fuel consumption",
                          style: TextStyle(color: AppColors.mainTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.buttonColor, width: 1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: years
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
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
                                  height: 43,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 43,
                          child: MyTextField(
                              controller: fuelConsumptionController),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "Registration",
                              style: TextStyle(color: AppColors.mainTextColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 43,
                            child:
                                MyTextField(controller: registrationController),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 43,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.camera_alt,
                                    color:
                                        isImageUploaded ? Colors.green : null),
                                onPressed: () async {
                                  imageUrlCar =
                                      await _repository.uploadImageCamera();
                                  if (imageUrlCar != null) {
                                    setState(() {
                                      isImageUploaded = true;
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 20),
                              IconButton(
                                icon: Icon(Icons.upload,
                                    color:
                                        isImageUploaded ? Colors.green : null),
                                onPressed: () async {
                                  imageUrlCar =
                                      await _repository.uploadImageGallery();
                                  if (imageUrlCar != null) {
                                    setState(() {
                                      isImageUploaded = true;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              MyElevatedButton(
                onPressed: () {},
                label: 'ADD NEW CAR',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
