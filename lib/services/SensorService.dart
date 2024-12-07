//SensorService.dart

import 'package:practiceflutter/models/Sensor.dart';

class SensorService{
  final List<Sensor> _sensores =[];


//Leer sensores:
 List<Sensor> getSensores(){
  return _sensores;
 }

//Agregar un nuevo sensor:

void addSensor(Sensor sensor){

  _sensores.add(sensor);
}

//Actualizar un sensor existente
void updateSensor (String id, Sensor updateSensor){
  final index= _sensores.indexWhere((sensor) =>sensor.id== id);
  if (index!= -1) {
    
    _sensores[index]=updateSensor;

  }  

}

//Eliminar un sensor:

void deleteSensor (String id){

  _sensores.removeWhere((sensor) => sensor.id==id);
}

}