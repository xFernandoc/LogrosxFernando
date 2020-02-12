import 'package:Instituto/boleta.dart';
import 'package:Instituto/inicio.dart';
import 'package:Instituto/models/Alumno.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User extends StatefulWidget {
  final Alumno alumno;
  User({this.alumno});

  @override
  _User createState() => new _User();
}

class _User extends State<User> {
  String url = "error";
  int _index=1;
  @override
  void initState() {
    super.initState();
    obtener();
  }

  @override
  Widget build(BuildContext context) {
    final sec1 = TextStyle(
        color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0);
    final sec2 = TextStyle(
        color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14.0);
    return Scaffold(
        body: new SingleChildScrollView(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ClipPath(
            child: new Container(
              height: 360.0,
              color: Color(0xffEF9600),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,top:8.0),
                        child: Text(
                          "Mi perfil",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 4.0),
                        shape: BoxShape.circle),
                    child: url != null
                        ? Image.network(url)
                        : CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                      child: Text(
                    "${widget.alumno.nombre} ${widget.alumno.apellidos}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  )),
                ],
              ),
            ),
            clipper: Cuadro(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Mis datos",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.red[900]),
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                              child: Text(
                            "Datos personales",
                            style: sec1,
                          )),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "D.N.I:",
                            style: sec2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text("${widget.alumno.dni}"),
                          ),
                          Divider(),
                          Text(
                            "Domicilio:",
                            style: sec2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child:
                                Text("${widget.alumno.localidad["direccion"]}"),
                          ),
                          Divider(),
                          Text(
                            "Distrito:",
                            style: sec2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child:
                                Text("${widget.alumno.localidad["distrito"]}"),
                          ),
                          Divider(),
                          Text(
                            "Provincia:",
                            style: sec2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child:
                                Text("${widget.alumno.localidad["provincia"]}"),
                          ),
                          Divider(),
                          Text("Fecha de nacimiento: ", style: sec2),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text("${widget.alumno.fechaNac}"),
                          ),
                          Divider(),
                          Text("Sexo:", style: sec2),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text("${widget.alumno.sexo}"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Datos de carrera",
                              style: sec1,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "Carrera: ",
                            style: sec2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                                "${widget.alumno.carrera["nombre_carrera"]}"),
                          ),
                          Divider(),
                          Text(
                            "Turno: ",
                            style: sec2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text(
                                turno(widget.alumno.turno["nombre_turno"])),
                          ),
                          Divider(),
                          Text(
                            "Ciclo: ",
                            style: sec2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text(ciclo(widget.alumno.ciclo)),
                          ),
                          Divider(),
                          Text(
                            "Tipo: ",
                            style: sec2,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child:
                                  Text("${widget.alumno.tipo["nombre_tipo"]}")),
                          Divider(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: <Widget>[
                Center(
                    child: Text(
                  "Contacto",
                  style: sec1,
                )),
                SizedBox(
                  height: 15.0,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Correo : ",
                          style: sec2,
                        ),
                        Text("${widget.alumno.correo}"),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Celular: ",
                            style: sec2,
                          ),
                        ),
                        Text("${widget.alumno.celular}")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(FontAwesomeIcons.facebook,color: Color(0xff3B5998),),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.email ,color: Color(0xffD44638),),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.twitter, color: Color(0xff00ACEE),),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.youtube, color: Color(0xffC4302B),),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Inicio(alumno: widget.alumno)));
                  break;
                case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Boleta(dni: widget.alumno.dni,alumno: widget.alumno,)));
              }
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home), title: Text("Inicio")),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user), title: Text("Mi perfil")),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.book), title: Text("Mi boleta de notas")),
          ],
        ),
    );
  }

  String turno(String id) {
    String mayus =
        widget.alumno.turno["nombre_turno"].toString()[0].toUpperCase() +
            widget.alumno.turno["nombre_turno"].substring(1);
    return mayus;
  }

  String ciclo(int x) {
    String nombre = "";
    switch (x) {
      case 1:
        nombre = "Primer ciclo";
        break;
      case 2:
        nombre = "Segundo ciclo";
        break;
      case 3:
        nombre = "Tercer ciclo";
        break;
      case 4:
        nombre = "Cuarto ciclo";
        break;
      case 5:
        nombre = "Quinto ciclo";
        break;
      case 6:
        nombre = "Sexto ciclo";
        break;
    }
    return nombre;
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
}

class Cuadro extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height + 15, size.width, size.height - 100);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
