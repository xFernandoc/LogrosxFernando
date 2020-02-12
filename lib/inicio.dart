import 'dart:async';

import 'package:Instituto/boleta.dart';
import 'package:Instituto/main.dart';
import 'package:Instituto/models/Alumno.dart';
import 'package:Instituto/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'main.dart';
import 'package:Instituto/models/Horario.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatefulWidget {
  final Alumno alumno;
  Inicio({this.alumno});

  @override
  _Inicio createState() => new _Inicio();
}

class _Inicio extends State<Inicio> {
  String url = "error";
  List<int> dias = new List<int>();
  Horario lunes;
  Horario martes;
  Horario miercoles;
  Horario jueves;
  Horario viernes;
  final List<Cursos> listacursosxlunes = new List<Cursos>();
  final List<Cursos> listacursosxmartes = new List<Cursos>();
  final List<Cursos> listacursosxmiercoles = new List<Cursos>();
  final List<Cursos> listacursosxviernes = new List<Cursos>();
  final List<Cursos> listacursosxjueves = new List<Cursos>();
  final refglobal = FirebaseDatabase.instance.reference().child("Horario");
  final List<List<Cursos>> totalcursos = new List<List<Cursos>>();

  int _index = 0;
  @override
  void initState() {
    super.initState();
    obtener();
    cargarhorario();
    cargarfecha();
  }

  void cargarhorario() {
    cargarcursos(lunes, "lunes", listacursosxlunes);
    cargarcursos(martes, "martes", listacursosxmartes);
    cargarcursos(miercoles, "miercoles", listacursosxmiercoles);
    cargarcursos(viernes, "jueves", listacursosxjueves);
    cargarcursos(lunes, "viernes", listacursosxviernes);
  }

  void cargarcursos(Horario dia, String dia2, List<Cursos> llenado) {
    final refxdia = refglobal
        .child(widget.alumno.carrera["nombre_carrera"])
        .child(widget.alumno.ciclo.toString())
        .child("bloque_1")
        .child(widget.alumno.turno["nombre_turno"]);

    setState(() {
      refxdia.child(dia2).once().then((DataSnapshot ds) {
        dia = Horario.fromsnapshot(ds);
        dia.cursos.forEach((valor) {
          llenado.add(valor);
        });
      });
      totalcursos.add(llenado);
    });
  }

  void cargarfecha() {
    setState(() {
      llenardias();
    });
  }

  void llenardias() {
    DateTime ahora = new DateTime.now();
    int i = 2;
    switch (i) {
      case 1:
        for (var i = 0; i < 5; i++) {
          DateTime fecha = new DateTime(ahora.year, ahora.month, ahora.day + i);
          dias.add(fecha.day);
        }
        break;
      case 2:
        DateTime fecha = new DateTime(ahora.year, ahora.month, ahora.day - 1);
        dias.add(fecha.day);
        for (var i = 0; i < 4; i++) {
          fecha = new DateTime(ahora.year, ahora.month, ahora.day + i);
          dias.add(fecha.day);
        }
        break;
      case 3:
        DateTime fecha = new DateTime(ahora.year, ahora.month, ahora.day - 2);
        dias.add(fecha.day);
        fecha = new DateTime(ahora.year, ahora.month, ahora.day - 1);
        dias.add(fecha.day);
        for (var i = 0; i < 3; i++) {
          fecha = new DateTime(ahora.year, ahora.month, ahora.day + i);
          dias.add(fecha.day);
        }
        break;
      case 4:
        DateTime fecha = new DateTime(ahora.year, ahora.month, ahora.day - 3);
        dias.add(fecha.day);
        fecha = new DateTime(ahora.year, ahora.month, ahora.day - 2);
        dias.add(fecha.day);
        fecha = new DateTime(ahora.year, ahora.month, ahora.day - 1);
        dias.add(fecha.day);
        for (var i = 0; i < 2; i++) {
          fecha = new DateTime(ahora.year, ahora.month, ahora.day + i);
          dias.add(fecha.day);
        }
        break;
      case 5:
        for (var x = 5; x > 0; x--) {
          DateTime dia =
              new DateTime(ahora.year, ahora.month, ahora.day - x + 1);
          dias.add(dia.day);
        }
        break;
      case 6:
        break;
      case 7:
        break;
    }
  }

  Widget build(BuildContext context) {
    final txt1 = TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold);
    final List<String> titulos = <String>[
      "Lunes",
      "Martes",
      "Miercoles",
      "Jueves",
      "Viernes"
    ];

    final List<String> horasacad = <String>[
      "07:45",
      "08:35",
      "09:25",
      "10:15",
      "11:05",
      "11:20",
      "12:10",
      "13:00"
    ];
    final color = [
      Color(0xff8d70fe),
      Color(0xff56ab2f),
      Color(0xffcb3a57),
      Color(0xff753a88),
      Color(0xffffafbd),
    ];
    final color2 = [
      Color(0xff2da9ef),
      Color(0xffa8e063),
      Color(0xffcb3a57),
      Color(0xffcc2b5e),
      Color(0xffffc3a0),
    ];
    final cabezera = UserAccountsDrawerHeader(
      accountName: Text(
        widget.alumno.nombre + " " + widget.alumno.apellidos,
        style: TextStyle(fontSize: 18.0),
      ),
      accountEmail: Text(
        widget.alumno.correo,
        style: TextStyle(fontSize: 14.0),
      ),
      currentAccountPicture: url != "error"
          ? CircleAvatar(
              child: Image.network(url),
            )
          : CircularProgressIndicator(),
      otherAccountsPictures: <Widget>[
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            size: 40.0,
          ),
          color: Colors.white,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Cerrar sesión"),
                    content: Text("¿Seguro que desea cerrar su sesión?"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => MiLogin()));
                        },
                        child: Text("Si"),
                      ),
                      FlatButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
        ),
      ],
    );
    final drawerItems = ListView(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 350,
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/logo.png"),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.user,
                          color: Color(0xff42275a),
                        ),
                        title: Text(
                          "Mi perfil",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>User(alumno: widget.alumno,)
                          ));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.payment,
                          color: Color(0xff42275a),
                        ),
                        title: Text(
                          "Estado de matricula",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.book,
                          color: Color(0xff42275a),
                        ),
                        title: Text(
                          "Mis cursos",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 130,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.location_on),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                      "Elvira garcia y garcia N° 699 - Chiclayo")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.call),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text("074-261006")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.email),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text("directora@istrfa.edu.pe")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.facebook),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text("Iestp Rep Fed Ale")
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 5.0,
                              left: 230.0,
                              child: IconButton(
                                icon: Image.asset("assets/federal.jpg"),
                                onPressed: (){},
                                iconSize: 50.0,
                                tooltip: "Acerca de..",
                          ))
                        ],
                      )),
                )
              ],
            ),
          ),
        )
      ],
    );
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(
              child: Text(
            "Bienvenido",
            style: TextStyle(color: Color(0xff42275a)),
          )),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: Drawer(
          child: drawerItems,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 5.0, left: 5.0),
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: url != "error"
                            ? Image.network(
                                url,
                                fit: BoxFit.contain,
                                height: 130.0,
                              )
                            : CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: SizedBox(
                          width: 2.0,
                          child: Container(color: Colors.grey[800]),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${widget.alumno.nombre} ${widget.alumno.apellidos}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[900]),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 6.00,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      "Carrera: ",
                                      style: txt1,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Text(carrera()),
                                    ),
                                    Text(
                                      "Ciclo: ",
                                      style: txt1,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Text(dvciclo()),
                                    ),
                                    Text(
                                      "Turno",
                                      style: txt1,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Text(turno()),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              child: Container(
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Mi horario",
                          style: TextStyle(
                              color: Color(0xff42275a), fontSize: 25.0),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          FontAwesomeIcons.calendar,
                          color: Color(0xff42275a),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Periodo : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                Text("Primero bloque"),
                                Spacer(),
                                Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: GestureDetector(
                                      child: Text("Ver horas académicas",
                                          style: TextStyle(
                                              color: Colors.red,
                                              decoration:
                                                  TextDecoration.underline)),
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Center(
                                                  child:
                                                      Text("Horas académicas"),
                                                ),
                                                content: Container(
                                                    height: 180.0,
                                                    child: SizedBox(
                                                        height: 150,
                                                        width: 290,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              horasacad.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int i) {
                                                            return i <= 6
                                                                ? Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          i == 4
                                                                              ? Text(
                                                                                  "Receso",
                                                                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                                                                )
                                                                              : Text(
                                                                                  "${i + 1}°",
                                                                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                                                                ),
                                                                          SizedBox(
                                                                            width:
                                                                                20.0,
                                                                          ),
                                                                          i == 4
                                                                              ? Text(
                                                                                  "${horasacad[i]} - ${horasacad[i + 1]} hrs.",
                                                                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                                                                )
                                                                              : Text(
                                                                                  "${horasacad[i]} - ${horasacad[i + 1]} hrs.",
                                                                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                                                                ),
                                                                        ],
                                                                      ),
                                                                      Divider(),
                                                                    ],
                                                                  )
                                                                : null;
                                                          },
                                                        ))),
                                              );
                                            });
                                      },
                                    ))
                              ],
                            ))
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ListView.builder(
                          itemCount: titulos.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 20.0,
                                  top: 18.0),
                              child: Container(
                                  width: 220,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      gradient: LinearGradient(
                                          colors: [color[0], color2[0]],
                                          begin: Alignment.center,
                                          end: Alignment.bottomLeft)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          titulos[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                            height: 100,
                                            width: 80,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                              border: Border.all(
                                                width: 4.0,
                                                color: obtColor(index),
                                              ),
                                            ),
                                            child: dias.length > 0
                                                ? Center(
                                                    child: Text(
                                                    dias[index].toString(),
                                                    style: TextStyle(
                                                        color: obtColor(index),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30.0),
                                                  ))
                                                : CircularProgressIndicator()),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                        child: Text("Curso",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17.0,
                                                            ))),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0),
                                                    child: Container(
                                                        width: 1.0,
                                                        height: 15,
                                                        color:
                                                            Color(0xffbdc3c7)),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                        child: Text("Horas",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    17.0))),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 115,
                                                        child: ListView.builder(
                                                          itemCount:
                                                              totalcursos[index]
                                                                  .length,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int numero) {
                                                            List<Cursos>
                                                                listtemp =
                                                                totalcursos[
                                                                    index];
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          15.0,
                                                                      right:
                                                                          10.0),
                                                              child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                print(listtemp[numero].idunidad);
                                                                              },
                                                                              child: Text(
                                                                                listtemp[numero].nombre,
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 8.0,
                                                                              right: 3.0),
                                                                          child: Container(
                                                                              height: 15.0,
                                                                              width: 1.0,
                                                                              color: Color(0xffbdc3c7)),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              listtemp[numero].horas,
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Divider(
                                                                      color: Color(
                                                                          0xffbdc3c7),
                                                                    )
                                                                  ]),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 13.0,
                                              ),
                                              Text(
                                                "(*) Click en el nombre del curso para más detalles",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11.0),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
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
                  break;
                case 1:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => User(
                                alumno: widget.alumno,
                              )));
                  _index = 0;
                  break;
                case 2:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Boleta(
                                dni: widget.alumno.dni,
                                alumno: widget.alumno,
                              )));
                  _index = 0;
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
                icon: Icon(FontAwesomeIcons.book),
                title: Text("Mi boleta de notas")),
          ],
        ),
      ),
    );
  }

  void obtener() async {
    StorageReference sr = FirebaseStorage.instance
        .ref()
        .child("perfiles")
        .child(widget.alumno.foto);
    String _sinc = await sr.getDownloadURL();
    setState(() {
      url = _sinc;
    });
  }

  String dvciclo() {
    String retorno = "";
    switch (widget.alumno.ciclo) {
      case 1:
        retorno = "Primer Ciclo";
        break;
      case 2:
        retorno = "Segundo Ciclo";
        break;
      case 3:
        retorno = "Tercer Ciclo";
        break;
      case 4:
        retorno = "Cuarto Ciclo";
        break;
      case 5:
        retorno = "Quinto Ciclo";
        break;
      case 6:
        retorno = "Sexto Ciclo";
        break;
    }
    return retorno;
  }

  String carrera() {
    return widget.alumno.carrera["nombre_carrera"];
  }

  String turno() {
    String mayus =
        widget.alumno.turno["nombre_turno"].toString()[0].toUpperCase() +
            widget.alumno.turno["nombre_turno"].substring(1);
    return mayus;
  }

  obtColor(int index) {
    DateTime hoy = new DateTime.now();
    int dia = hoy.weekday;
    if ((index + 1) == dia) {
      return Colors.yellow;
    } else {
      return Colors.white;
    }
  }
}
