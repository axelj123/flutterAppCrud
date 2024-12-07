import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practiceflutter/models/Sensor.dart';

class SensorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Leer sensores desde Firestore:
  Future<List<Sensor>> getSensores() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('sensores').get();
      List<Sensor> sensores = snapshot.docs.map((doc) {
        return Sensor(
          id: doc.id, // Firestore crea un ID automáticamente
          idSensor: doc['idSensor'],
          fecha: doc['fecha'],
          hora: doc['hora'],
          valor: doc['valor'],
        );
      }).toList();
      return sensores;
    } catch (e) {
      throw Exception('Error al obtener sensores: $e');
    }
  }

  // Agregar un nuevo sensor a Firestore:
  Future<void> addSensor(Sensor sensor) async {
    try {
      await _firestore.collection('sensores').add({
        'idSensor': sensor.idSensor,
        'fecha': sensor.fecha,
        'hora': sensor.hora,
        'valor': sensor.valor,
      });
    } catch (e) {
      throw Exception('Error al agregar sensor: $e');
    }
  }

  // Actualizar un sensor existente:
  Future<void> updateSensor(String sensorId, Sensor sensor) async {
    try {
      await _firestore.collection('sensores').doc(sensorId).update({
        'idSensor': sensor.idSensor,
        'fecha': sensor.fecha,
        'hora': sensor.hora,
        'valor': sensor.valor,
      });
    } catch (e) {
      throw Exception('Error al actualizar sensor: $e');
    }
  }

  // Eliminar un sensor:
  Future<void> deleteSensor(String sensorId) async {
    try {
      await _firestore.collection('sensores').doc(sensorId).delete();
    } catch (e) {
      throw Exception('Error al eliminar sensor: $e');
    }
  }
}
