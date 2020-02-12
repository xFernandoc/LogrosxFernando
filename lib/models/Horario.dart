import 'package:firebase_database/firebase_database.dart';
class Horario{
  List<Cursos> cursos;

  Horario({this.cursos});

  Horario.fromsnapshot(DataSnapshot ds){
    cursos = new List<Cursos>();
    ds.value["cursos"].forEach((v){
      cursos.add(new Cursos.fromSnapshot(v.toString()));
    });
  }
}

class Cursos {
  String horas;
  String idunidad;
  String nombre;

  Cursos({this.horas,this.idunidad,this.nombre});

  Cursos.fromSnapshot(String ds){
    
    horas = ds.substring(8,ds.indexOf(","));
    idunidad = ds.substring(ds.indexOf(",")+13,ds.indexOf(", nombre"));
    int cant = ds.indexOf("nombre:")+8;
    nombre = ds.substring(cant,ds.length-1);
  }
}