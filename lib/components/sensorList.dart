import 'package:flutter/material.dart';

class SensorList extends StatelessWidget {
  const SensorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: ListTile(
                    title: Text('Sensor $index'),
                    subtitle: Text('Descripción del sensor $index'),
                    leading: const Icon(Icons.device_thermostat),
                  ),
                );
              },
              childCount: 20, // Número de items en la lista
            ),
          ),
        ],
      ),
    );
  }
}
