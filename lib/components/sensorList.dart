import 'package:flutter/material.dart';
import 'package:practiceflutter/models/Sensor.dart';

class SensorList extends StatelessWidget {
  final List<Sensor> sensors;
  final Function(Sensor) onEdit;
  final Function(Sensor) onDelete;

  const SensorList({
    Key? key,
    required this.sensors,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: sensors.isEmpty
          ? const Center(child: Text('No sensors found'))
          : ListView.builder(
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    title: Text('Sensor ID: ${sensor.idSensor}'),
                    subtitle: Text(
                        'Fecha: ${sensor.fecha}, Hora: ${sensor.hora}, Valor: ${sensor.valor}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => onEdit(sensor),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => onDelete(sensor),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
