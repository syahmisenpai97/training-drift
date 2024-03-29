import 'package:flutter/material.dart';
import 'package:training_drift/data/local/db/app_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDb _db;

  @override
  void initState() {
    super.initState();
    _db = AppDb();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: FutureBuilder<List<EmployeeData>>(
        future: _db.getEmployees(),
        builder: (context, snapshot) {
          final List<EmployeeData>? employees = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (employees != null) {
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return GestureDetector(
                  child: Card(
                    color: Colors.green[300],
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green,
                          style: BorderStyle.solid,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employee.id.toString()),
                          Text(employee.userName.toString()),
                          Text(employee.firstName.toString()),
                          Text(employee.lastName.toString()),
                          Text(employee.dateOfBirth.toString()),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/edit_employee", arguments: employee.id);
                  },
                );
              },
            );
          }

          return const Center(
            child: Text("No data available"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/add_employee",
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Employee"),
      ),
    );
  }
}
