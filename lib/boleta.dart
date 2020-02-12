import 'package:Instituto/inicio.dart';
import 'package:Instituto/models/Alumno.dart';
import 'package:Instituto/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Boleta extends StatefulWidget {
  final String dni;
  final Alumno alumno;
  Boleta({this.dni, this.alumno});
  @override
  _Boleta createState() => new _Boleta();
}

class _Boleta extends State<Boleta> {
  int desaprobado = 0;
  final DatabaseReference refglobal =
      FirebaseDatabase.instance.reference().child("detalles");
  String nuevovalor;
  Map<String, Unidades> unidades;
  Map<String, DetUnidades> detunid;
  static const menuItems = <String>[
    "Primer ciclo",
    "Segundo ciclo",
    "Tercer ciclo",
    "Cuarto ciclo",
    "Quinto ciclo",
    "Sexto ciclo",
  ];
  final List<DropdownMenuItem<String>> _dropitems = menuItems
      .map((valor) => DropdownMenuItem<String>(
            value: valor,
            child: Text(valor),
          ))
      .toList();
  int _index = 2;
  String seleccion = "Primer ciclo";
  @override
  void initState() {
    super.initState();
    cargarnotas();
  }

  void cargarnotas() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.school),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      "Mi boleta de notas",
                      style: TextStyle(
                          color: Color(0xff42275a),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Escoga el ciclo: ",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: DropdownButton<String>(
                        value: seleccion,
                        onChanged: (String valornuevo) {
                          setState(() {
                            seleccion = valornuevo;
                            unidades = new Map<String, Unidades>();
                            detunid = new Map<String, DetUnidades>();
                            refglobal
                                .child(widget.dni)
                                .child(llenar(valornuevo))
                                .once()
                                .then((DataSnapshot ds) {
                              Map<dynamic, dynamic> values = ds.value;
                              setState(() {
                                desaprobado = 0;
                                values.forEach((key, valor) {
                                  unidades[key] = new Unidades(
                                      nota1: valor["nota_1"].toString(),
                                      nota2: valor["nota_2"].toString(),
                                      promedio: valor["promedio"].toString());
                                  if (valor["promedio"] != " ") {
                                    if (valor["promedio"]
                                            .toString()
                                            .substring(0, 1) ==
                                        "0") {
                                      desaprobado++;
                                    } else {
                                      if (valor["promedio"] < 13) {
                                        desaprobado++;
                                      }
                                    }
                                  }
                                });
                              });
                            });
                            //Nombres unidades
                            DatabaseReference refxunidades = FirebaseDatabase
                                .instance
                                .reference()
                                .child("Cursos")
                                .child(widget.alumno.carrera["nombre_carrera"])
                                .child(llenar(valornuevo));
                            refxunidades.once().then((DataSnapshot ds) {
                              Map<dynamic, dynamic> values = ds.value;
                              setState(() {
                                values.forEach((key, valor) {
                                  detunid[key] =
                                      new DetUnidades(nombre: valor["nombre"]);
                                });
                              });
                            });
                          });
                        },
                        items: this._dropitems,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
              height: 30,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 190.0,
                      child: Text(
                        "Unidad didáctica",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        width: 2.0,
                        height: 25.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Container(
                      width: 45.0,
                      child: Center(
                          child: Text(
                        "Nota 1",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                      child: Container(
                        width: 2.0,
                        height: 25.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Container(
                      width: 45.0,
                      child: Center(
                        child: Text(
                          "Nota 2",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                      child: Container(
                        width: 2.0,
                        height: 25.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Container(
                      width: 65.0,
                      child: Text(
                        "Promedio",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
                height: 450,
                width: double.infinity,
                child: unidades != null
                    ? ListView.builder(
                        itemCount: unidades.length,
                        itemBuilder: (BuildContext contex, int x) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 190.0,
                                      height: 30.0,
                                      child: detunid.length > 0
                                          ? Text(
                                              detunid["U_${x + 1}"].nombre,
                                              textAlign: TextAlign.left,
                                            )
                                          : LinearProgressIndicator(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Container(
                                        width: 2.0,
                                        color: Colors.grey[300],
                                        height: 25.0,
                                      ),
                                    ),
                                    Container(
                                        height: 30.0,
                                        width: 40,
                                        child: unidades["U_${x + 1}"].nota1 == " "
                                            ? Center(child: Text("-"))
                                            : int.parse(unidades["U_${x + 1}"].nota1) < 13
                                                ? Center(
                                                    child: Text(
                                                        unidades["U_${x + 1}"]
                                                            .nota1,
                                                        style: TextStyle(
                                                            color: Colors.red)))
                                                : Center(
                                                    child: Text(
                                                        unidades["U_${x + 1}"]
                                                            .nota1,
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                        textAlign:
                                                            TextAlign.center))),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Container(
                                        width: 2.0,
                                        color: Colors.grey[300],
                                        height: 25.0,
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 40,
                                      child: unidades["U_${x + 1}"].nota2 == " "
                                          ? Center(child: Text("-"))
                                          : int.parse(unidades["U_${x + 1}"].nota2) <
                                                  13
                                              ? Center(
                                                  child: Text(
                                                      unidades["U_${x + 1}"]
                                                          .nota2,
                                                      style: TextStyle(
                                                          color: Colors.red)))
                                              : Center(
                                                  child: Text(
                                                      unidades["U_${x + 1}"]
                                                          .nota2,
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                      textAlign:
                                                          TextAlign.center)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 18.0),
                                      child: Container(
                                        width: 2.0,
                                        color: Colors.grey[300],
                                        height: 25.0,
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 40,
                                      child: unidades["U_${x + 1}"].promedio == " "
                                          ? Center(child: Text("-"))
                                          : int.parse(unidades["U_${x + 1}"].promedio) <
                                                  13
                                              ? Center(
                                                  child: Text(
                                                      unidades["U_${x + 1}"]
                                                          .promedio,
                                                      style: TextStyle(
                                                          color: Colors.red)))
                                              : Center(
                                                  child: Text(
                                                      unidades["U_${x + 1}"]
                                                          .promedio,
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                      textAlign:
                                                          TextAlign.center)),
                                    ),
                                  ],
                                ),
                              ),
                              Divider()
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      )),
            unidades != null
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Container(
                        height: 50,
                        color: desaprobado == 0
                            ? Colors.green.withOpacity(0.4)
                            : Colors.red.withOpacity(0.4),
                        child: desaprobado == 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.mood,
                                      color: Colors.green[900],
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text(
                                      "Buena!\nNo tienes ningun curso desaprobado",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.sadCry,
                                      color: Colors.red[900],
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text(
                                      desaprobado == 1
                                          ? "Tienes $desaprobado curso desaprobado."
                                          : "Tienes $desaprobado cursos desaprobados.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    desaprobado > 0
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.help,
                                              color: Colors.blue[900],
                                            ),
                                            onPressed: () {
                                            },
                                            splashColor: Colors.red,
                                            tooltip: "Ayuda",
                                          )
                                        : Text(""),
                                  ],
                                ))),
                  )
                : Text(""),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color(0xff42275a),
        currentIndex: _index,
        showUnselectedLabels: true,
        unselectedItemColor: Color(0xff8d70fe),
        onTap: (int index) {
          setState(() {
            _index = index;
            switch (index) {
              case 0:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Inicio(
                        alumno: widget.alumno,
                      ),
                    ));
                break;
              case 1:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => User(
                              alumno: widget.alumno,
                            )));
                break;
              case 2:
                break;
              default:
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home), title: Text("Inicio")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user), title: Text("Mi perfil")),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text("Boleta de notas")),
        ],
      ),
    );
  }

  String llenar(String valor) {
    String nuevo = "";
    switch (valor) {
      case "Primer ciclo":
        nuevo = "Ciclo_1";
        break;
      case "Segundo ciclo":
        nuevo = "Ciclo_2";
        break;
      case "Tercer ciclo":
        nuevo = "Ciclo_3";
        break;
      case "Cuarto ciclo":
        nuevo = "Ciclo_4";
        break;
      case "Quinto ciclo":
        nuevo = "Ciclo_5";
        break;
      case "Sexto ciclo":
        nuevo = "Ciclo_6";
        break;
      default:
    }
    return nuevo;
  }
}

class Unidades {
  String nota1;
  String nota2;
  String promedio;
  Unidades({this.nota1, this.nota2, this.promedio});
}

class DetUnidades {
  String nombre;
  DetUnidades({this.nombre});
}
