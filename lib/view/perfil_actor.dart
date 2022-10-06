import 'package:cinema_aldo_test/view/detalle.dart';
import 'package:cinema_aldo_test/widget/rutasPeliculas.dart';
import 'package:flutter/material.dart';
import 'package:cinema_aldo_test/models/apiActores.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PerfilActor extends StatefulWidget {
  const PerfilActor(this.id, {super.key});
  final int id;

  @override
  State<PerfilActor> createState() => _PerfilActorState(this.id);
}

class _PerfilActorState extends State<PerfilActor> {
  _PerfilActorState(this.id);
  final int id;

  late Future<List<ApiActores>> _listaApiActores;
  Future<List<ApiActores>> _getApiActores() async {
    var url = Uri.https(
      'api.themoviedb.org',
      '/3/person/${id.toString()}',
      {
        'api_key': 'b98e695aefa00e6545213e5c1f1500d6',
        'append_to_response': 'credits'
      },
    );
    final response = await http.get(url);
    List<ApiActores> apisActor = [];

    if (response.statusCode == 200) {
      String info = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(info);

      var idActor = jsonData['id'];
      String nombreActor = jsonData['name'];
      String biografiaActor = jsonData['biography'];
      String urlFotoActor =
          'https://image.tmdb.org/t/p/w500/${jsonData['profile_path']}';
      List creditos = jsonData['credits']['cast'];

      apisActor.add(
        ApiActores(
            idActor, nombreActor, biografiaActor, urlFotoActor, creditos),
      );

      return apisActor;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listaApiActores = _getApiActores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 40, 233, 88),
                      Color.fromARGB(255, 15, 157, 201)
                    ])),
                child: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _listaApiActores,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final size = MediaQuery.of(context).size;
            var urlFoto = snapshot.data[0].urlFoto;
            var nombreActor = snapshot.data[0].nombre;
            var biografiaActor = snapshot.data[0].biografia;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      width: 63,
                      height: 63,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: NetworkImage(urlFoto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 256,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombreActor,
                            style: GoogleFonts.baloo2(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 22,
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            biografiaActor,
                            maxLines: 5,
                            style: GoogleFonts.baloo2(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Casted on',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.baloo2(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 36,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height - 300,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: _listApiActores(snapshot.data),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _listApiActores2(snapshot.data),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> _listApiActores(data) {
    List<Widget> apisPeliculas = [];
    int index = 1;
    var foto;
    for (var api in data[0].creditos) {
      if (index.isEven == false) {
        if (api['poster_path'] == null) {
          foto = const AssetImage("assets/img/noPhoto.jpg");
        } else {
          foto = NetworkImage(
              "https://image.tmdb.org/t/p/w500/${api['poster_path']}");
        }
        apisPeliculas.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                RutasAnimationPeliculas(
                  child: Detalle(
                      api['id'],
                      api['original_title'],
                      api['vote_average'].round() * 10,
                      "https://image.tmdb.org/t/p/w500/${api['poster_path']}"),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 26),
              height: 218,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: foto, fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      height: 59,
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            api['original_title'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.baloo2(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${api['vote_average'].round() * 10}% User Score',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.baloo2(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      index++;
    }
    return apisPeliculas;
  }

  List<Widget> _listApiActores2(data) {
    int index2 = 1;
    List<Widget> apisPeliculas = [];
    double topMargin = 0;
    var foto;
    for (var api in data[0].creditos) {
      if (index2.isEven) {
        if (index2 == 2) {
          topMargin = 30;
        } else {
          topMargin = 0;
        }
        if (api['poster_path'] == null) {
          foto = const AssetImage("assets/img/noPhoto.jpg");
        } else {
          foto = NetworkImage(
              "https://image.tmdb.org/t/p/w500/${api['poster_path']}");
        }
        apisPeliculas.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                RutasAnimationPeliculas(
                  child: Detalle(
                      api['id'],
                      api['original_title'],
                      api['vote_average'].round() * 10,
                      "https://image.tmdb.org/t/p/w500/${api['poster_path']}"),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 26,
                top: topMargin,
              ),
              height: 218,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: foto, fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      height: 59,
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            api['original_title'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.baloo2(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${api['vote_average'].round() * 10}% User Score',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.baloo2(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      index2++;
    }
    return apisPeliculas;
  }
}
