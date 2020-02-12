

import 'package:Instituto/inicio.dart';
import 'package:Instituto/models/Alumno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';


void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instituto',
      home: MiLogin(),
    ));

class MiLogin extends StatefulWidget {
  @override
  _MiLogin createState() => new _MiLogin();
}

class _MiLogin extends State<MiLogin> {

  var _encendido = true;
  Alumno alumno;
  final myUser = TextEditingController();
  final myPass = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    myUser.dispose();
    myPass.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/student.png",
              width: 100,
              height: 150,
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    //tipo de border ,
                    border: OutlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    labelText: 'Usuario',
                  ),
                  controller: myUser,
                )),
            SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextField(
                  obscureText: _encendido,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Clave',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _encendido = !_encendido;
                          });
                        },
                        child: new Icon(_encendido
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )),
                  controller: myPass,
                )),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: GestureDetector(
                    onTap: () {
                      //Toast.show("Toast plugin app", context,
                      //    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    },
                    child: Text(
                      "Olvidé mi contraseña",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: RaisedButton(
                    child: Text(
                      "Ingresar",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_validar()) {
                        _conexion(context);
                      } else {
                        setState(() {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Campos incompletos",
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                  content:
                                      Text("Complete los campos requeridos"),
                                );
                              });
                        });
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  bool _validar() {
    bool msg;
    myUser.text != "" || myPass.text != "" ? msg = true : msg = false;
    return msg;
  }

  void _conexion(BuildContext context) async {
    String id = myUser.text;
    String clave = myPass.text;
    final referencia = FirebaseDatabase.instance.reference().child("estudiante").child(id);
    referencia.once().then((DataSnapshot ds){
      if(ds.value.toString()!="null"){
        alumno =Alumno.fromSnapshot(ds);
        if(alumno.clave==clave){
          alumno.dni=myUser.text;
          Navigator.push(context, new MaterialPageRoute(
            builder: (context) => Inicio(alumno: alumno,)
          ));
        }else{
          error(context);
        }
      }else{
        error(context);
      }
    });
  }

  void error(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Credenciales incorrectas",
                style: TextStyle(color: Colors.redAccent)),
            content: Text("Verifica tu usuario y clave"),
            shape:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          );
        });
  }
}
