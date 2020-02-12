import 'package:Instituto/models/Alumno.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Curricula extends StatefulWidget{
  final Alumno alumno;
  Curricula({this.alumno});
  @override
  _Curricula createState() => new _Curricula();
}
class _Curricula extends State<Curricula>{
  @override
  void initState() {
    super.initState();
    cargardatos();
  }

  void cargardatos(){
     DatabaseReference ref = FirebaseDatabase.instance.reference().child("Cursos");
     ref.once().then((DataSnapshot ds){
       print(ds.value);
     });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      
    );
  }
}