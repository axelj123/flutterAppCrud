import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practiceflutter/components/appbar_custom.dart';
import 'package:practiceflutter/models/Sensor.dart';
import 'package:practiceflutter/services/SensorService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SensorService _sensorService = SensorService();

  // Controllers for sensor input fields
  final TextEditingController _idSensorController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (_picked != null) {
      setState(() {
        _fechaController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        // Format the time as a string
        _horaController.text = pickedTime.format(context);
      });
    }
  }

  // Method to show Add/Edit Sensor Dialog
  void _showSensorDialog({Sensor? existingSensor}) {
    // If editing an existing sensor, pre-fill the controllers
    if (existingSensor != null) {
      _idSensorController.text = existingSensor.idSensor;
      _fechaController.text = existingSensor.fecha;
      _horaController.text = existingSensor.hora;
      _valorController.text = existingSensor.valor.toString();
    } else {
      // Clear controllers for new sensor
      _idSensorController.clear();
      _fechaController.clear();
      _horaController.clear();
      _valorController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ),
        );
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7, // Ajusta la altura
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          existingSensor == null
                              ? "Registrar Sensor"
                              : "Editar Sensor",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _idSensorController,
                          decoration: const InputDecoration(

                            labelText: 'Sensor ID',
                            helperText: 'Ingresa un ID para el sensor',
                       
                            
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _fechaController,
                          decoration: const InputDecoration(
                              labelText: 'Fecha',
                              helperText: 'Selecciona una fecha'),
                          readOnly: true,
                          onTap: _selectDate,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _horaController,
                          decoration: const InputDecoration(
                              labelText: 'Hora',
                              helperText: 'Selecciona un horario'),
                          readOnly: true,
                          onTap: _selectTime,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _valorController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Valor',
                              helperText: 'Ingresa el valor'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.red, // Establece el color del texto
                              ),
                              child: const Text(
                                  'Cancel'), // El 'child' está al final
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Validate inputs
                                if (_idSensorController.text.isNotEmpty &&
                                    _fechaController.text.isNotEmpty &&
                                    _horaController.text.isNotEmpty &&
                                    _valorController.text.isNotEmpty) {
                                  // Create or update sensor
                                  final sensor = Sensor(
                                    id: existingSensor?.id ??
                                        Random().nextInt(10000).toString(),
                                    idSensor: _idSensorController.text,
                                    fecha: _fechaController.text,
                                    hora: _horaController.text,
                                    valor: int.parse(_valorController.text),
                                  );

                                  setState(() {
                                    if (existingSensor == null) {
                                      // Add new sensor
                                      _sensorService.addSensor(sensor);
                                    } else {
                                      // Update existing sensor
                                      _sensorService.updateSensor(
                                          existingSensor.id, sensor);
                                    }
                                  });

                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                existingSensor == null ? 'Add' : 'Update',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Method to delete a sensor
  void _deleteSensor(Sensor sensor) {
    setState(() {
      _sensorService.deleteSensor(sensor.id);
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const AppbarCustom(),
            const SizedBox(height: 10),
            // Using FutureBuilder to load the sensor data from Firestore
            Expanded(
              child: FutureBuilder<List<Sensor>>(
                future: _sensorService.getSensores(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No sensors found'));
                  } else {
                    final sensors = snapshot.data!;
                    return ListView.builder(
                      itemCount: sensors.length,
                      itemBuilder: (context, index) {
                        final sensor = sensors[index];
                        return ListTile(
                          title: Text('Sensor ID: ${sensor.idSensor}'),
                          subtitle: Text(
                              'Fecha: ${sensor.fecha}, Hora: ${sensor.hora}, Valor: ${sensor.valor}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showSensorDialog(existingSensor: sensor),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteSensor(sensor),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () => _showSensorDialog(),
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );
}

}