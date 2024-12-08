import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practiceflutter/components/appbar_custom.dart';
import 'package:practiceflutter/components/sensorList.dart';
import 'package:practiceflutter/models/Sensor.dart';
import 'package:practiceflutter/services/SensorService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SensorService _sensorService = SensorService();

  final TextEditingController _idSensorController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Sensor> _allSensors = [];
  List<Sensor> _filteredSensors = [];
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
        _horaController.text = pickedTime.format(context);
      });
    }
  }

  void _filterSensors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSensors = _allSensors;
      } else {
        _filteredSensors = _allSensors.where((sensor) {
          return sensor.idSensor
                  .toLowerCase()
                  .contains(query.toLowerCase().trim()) ||
              sensor.fecha.toLowerCase().contains(query.toLowerCase().trim()) ||
              sensor.hora.toLowerCase().contains(query.toLowerCase().trim()) ||
              sensor.valor
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase().trim());
        }).toList();
      }
    });
  }

  void _showSensorDialog({Sensor? existingSensor}) {
    if (existingSensor != null) {
      _idSensorController.text = existingSensor.idSensor;
      _fechaController.text = existingSensor.fecha;
      _horaController.text = existingSensor.hora;
      _valorController.text = existingSensor.valor.toString();
    } else {
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
          height: MediaQuery.of(context).size.height * 0.7,
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
              child: SingleChildScrollView(
                child: Padding(
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
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
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
                            labelText: 'Valor', helperText: 'Ingresa el valor'),
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
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Cancel'),
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
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar sensor',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterSensors, // Filtrar cuando el texto cambie
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Sensor>>(
                stream: _sensorService.streamSensores(), // Usar streamSensores() para escuchar cambios en tiempo real
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No se encontraron sensores'));
                  } else {
                    _allSensors = snapshot.data!; // Guardamos los sensores obtenidos en _allSensors

                    // Filtrar los sensores si el campo de búsqueda no está vacío
                    List<Sensor> sensorsToShow = _filteredSensors.isEmpty ? _allSensors : _filteredSensors;

                    return SensorList(
                      sensors: sensorsToShow,
                      onEdit: (sensor) => _showSensorDialog(existingSensor: sensor),
                      onDelete: _deleteSensor,
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
      mini: true,
      onPressed: () => _showSensorDialog(), 
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );
}
}