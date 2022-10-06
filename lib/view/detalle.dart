import 'package:cinema_aldo_test/models/apiCreditos.dart';
import 'package:cinema_aldo_test/view/perfil_actor.dart';
import 'package:cinema_aldo_test/widget/rutasActores.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Detalle extends StatefulWidget {
  const Detalle(this.id, this.titulo, this.vote, this.url, {super.key});
  final String url, titulo;
  final int id, vote;

  @override
  State<Detalle> createState() =>
      _DetalleState(this.id, this.titulo, this.vote, this.url);
}

class _DetalleState extends State<Detalle> {
  _DetalleState(this.id, this.titulo, this.vote, this.url);
  final String url, titulo;
  final int id, vote;

  late Future<List<ApiCreditos>> _listaApiCreditos;
  Widget? image = Container();
  bool visible = false;
  double sizeVisible = 150;

  Future<List<ApiCreditos>> _getApiPeliculasCreditos() async {
    var url = Uri.https(
      'api.themoviedb.org',
      '/3/movie/${id.toString()}/credits',
      {'api_key': 'b98e695aefa00e6545213e5c1f1500d6'},
    );
    final response = await http.get(url);
    List<ApiCreditos> apisCreditos = [];
    if (response.statusCode == 200) {
      String info = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(info);

      for (var item in jsonData['cast']) {
        int idCast = item['id'];
        String nombreCast = item['name'];
        String caracterCast = item['character'];
        String urlCastFoto = item['profile_path'] == null
            ? 'N/A'
            : 'https://image.tmdb.org/t/p/w500${item['profile_path']}';

        apisCreditos.add(
          ApiCreditos(
            idCast,
            nombreCast,
            caracterCast,
            urlCastFoto,
          ),
        );
      }

      return apisCreditos;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listaApiCreditos = _getApiPeliculasCreditos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  Icons.close,
                  size: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _listaApiCreditos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                if (visible) {
                  setState(() {
                    visible = false;
                    sizeVisible = 150;
                  });
                } else {
                  setState(() {
                    visible = true;
                    sizeVisible = 268;
                  });
                }
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      url,
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        height: sizeVisible,
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxHeight: double.infinity,
                          minHeight: 59,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              titulo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.baloo2(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 42,
                                ),
                              ),
                            ),
                            Text(
                              '${vote.toString()}% User Score',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.baloo2(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Visibility(
                                visible: visible,
                                child: Row(
                                  children:
                                      _listApiPeliculascreditos(snapshot.data),
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
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> _listApiPeliculascreditos(data) {
    List<Widget> apisCreditos = [];
    var foto;
    for (var api in data) {
      if (api.urlFoto == 'N/A') {
        foto = const AssetImage("assets/img/noPhoto.jpg");
      } else {
        foto = NetworkImage(api.urlFoto);
      }

      apisCreditos.add(
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              RutasAnimationActores(
                  child: PerfilActor(api.id), direction: AxisDirection.left),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 15),
            height: 140,
            width: 100,
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
                    height: 65,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          api.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.baloo2(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          api.caracter,
                          maxLines: 1,
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
    return apisCreditos;
  }
}
