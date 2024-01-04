import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_drift/data/local/db/app_db.dart';
import 'package:training_drift/widget/custom_text_form_field.dart';
import 'package:training_drift/widget/cutom_date_picker_form_field.dart';
import 'package:drift/drift.dart' as drift;

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  late AppDb _db;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _db = AppDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final entity = EmployeeCompanion(
                userName: drift.Value(_userNameController.text),
                firstName: drift.Value(_firstNameController.text),
                lastName: drift.Value(_lastNameController.text),
                dateOfBirth: drift.Value(_dateOfBirth!),
              );
              _db.insertEmployee(entity).then((value) => ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                    content: Text("New employee inserted: $value"),
                    actions: [
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                        child: Text("close"),
                      )
                    ],
                  )));
            },
            icon: const Icon(
              Icons.save,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFormField(controller: _userNameController, txtLabel: "UserName"),
            const SizedBox(height: 20.0),
            CustomTextFormField(controller: _firstNameController, txtLabel: "First Name"),
            const SizedBox(height: 20.0),
            CustomTextFormField(controller: _lastNameController, txtLabel: "Last Name"),
            const SizedBox(height: 20.0),
            CustomDatePickerFormFiled(
                controller: _dateOfBirthController,
                txtLabel: "Date of Birth",
                callback: () {
                  pickDateOfBirth(context);
                }),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: _dateOfBirth ?? initialDate,
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 1),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child ?? const Text(""),
            ));

    if (newDate == null) {
      return;
    }

    setState(() {
      _dateOfBirth = newDate;
      String dob = DateFormat("dd/MM/yyyy").format(newDate);
      _dateOfBirthController.text = dob;
    });
  }
}
