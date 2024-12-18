//Sensor.dart

class Sensor {
  final String id;
  final String idSensor;
  final String fecha;
  final String hora;
  final int valor;

  Sensor({
    required this.id,
    required this.idSensor,
    required this.fecha,
    required this.hora,
    required this.valor,
  });

  factory Sensor.fromFirestore(Map<String, dynamic> firestoreData,String id){
    return Sensor(
      id:id,
      idSensor: firestoreData ['idSensor'],
      fecha: firestoreData ['fecha'],
      hora:firestoreData['hora'],
      valor:firestoreData['valor'],
    );
  }

}
