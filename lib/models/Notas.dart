import 'package:firebase_database/firebase_database.dart';

class Notas {
  Map<String,dynamic> ciclos;

  Notas.fromSnapshot(Map<dynamic,dynamic> valores) {
    ciclos = new Map<String,dynamic>();
    valores.forEach((key,valor){
      ciclos[key]=valor;
    });
  }
}

