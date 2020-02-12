import 'package:firebase_database/firebase_database.dart';

class Alumno {
  String apellidos;
  var clave;
  String correo;
  String fechaNac;
  String foto;
  String nombre;
  int ciclo;
  Map<String,String> tipo;
  Map<String,String> turno;
  Map<String,String> carrera;
  Map<String,String> localidad;
  String dni;
  var celular;
  String sexo;
  Alumno(
      {this.apellidos,
      this.clave,
      this.correo,
      this.fechaNac,
      this.foto,
      this.nombre,
      this.tipo,
      this.turno,
      this.ciclo,this.carrera,this.localidad,this.dni,this.celular,this.sexo});

  Alumno.fromSnapshot(DataSnapshot sp) {
    apellidos = sp.value['apellidos'];
    clave = sp.value['clave'];
    correo = sp.value['correo'];
    fechaNac = sp.value['fecha_nac'];
    foto = sp.value['foto'];
    nombre = sp.value['nombre'];
    ciclo=sp.value['Ciclo'];
    celular = sp.value['celular'];
    sexo = sp.value['sexo'];
    String _tipo = sp.value['tipo'].toString();
    String _turno = sp.value['turno'].toString();
    tipo = new Map();
    tipo['id_tipo']=_tipo.substring(10,_tipo.indexOf(","));
    tipo['nombre_tipo']=_tipo.substring(_tipo.indexOf(",")+10,_tipo.length-1);
    turno = new Map();
    if(_turno==" "){
      turno=null;
    }else{
      turno['id_turno']= _turno.substring(5,_turno.indexOf(","));
      turno['nombre_turno'] = _turno.substring(_turno.indexOf(",")+10,_turno.length-1);
    }
    String _carrera = sp.value['carrera'].toString();
    carrera = new Map();
    carrera['id_carrera']=_carrera.substring(13,_carrera.indexOf(","));
    carrera['nombre_carrera']=_carrera.substring(_carrera.indexOf(",")+10,_carrera.length-1);

    String _localidad = sp.value['Localidad'].toString();
    localidad = new Map();
    localidad["direccion"] = _localidad.substring(_localidad.indexOf("Dirección: ")+11,_localidad.indexOf(" Distrito: ")-1);
    localidad["distrito"] = _localidad.substring(_localidad.indexOf("Distrito: ")+10,_localidad.indexOf(" Departamento: ")-1);
    localidad["departamento"] = _localidad.substring(_localidad.indexOf(" Departamento: ")+15,_localidad.indexOf(" Provincia: ")-1);
    localidad["provincia"] = _localidad.substring(_localidad.indexOf(" Provincia: ")+12,_localidad.length-1);
  }

  toJson() {
    return{
      "apellidos":apellidos,
      "clave" : clave,
      "correo":correo,
      "fecha_nac":fechaNac,
      "foto" : foto,
      "nombre":nombre,
      "Ciclo":ciclo,
    };
  }
}