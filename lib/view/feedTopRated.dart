import 'package:cinema_aldo_test/view/detalle.dart';
import 'package:cinema_aldo_test/view/feedPopular.dart';
import 'package:cinema_aldo_test/view/feedUpcoming.dart';
import 'package:cinema_aldo_test/widget/rutasPeliculas.dart';
import 'package:flutter/material.dart';
import 'package:cinema_aldo_test/models/apiPeliculas.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedViewTopRated extends StatefulWidget {
  const FeedViewTopRated({super.key});

  @override
  State<FeedViewTopRated> createState() => _FeedViewTopRatedState();
}

class _FeedViewTopRatedState extends State<FeedViewTopRated> {
  late Future<List<ApiPeliculas>> _listaApiPeliculas;

  Future<List<ApiPeliculas>> _getApiPeliculas() async {
    var url = Uri.https('api.themoviedb.org', '/3/movie/top_rated',
        {'api_key': 'b98e695aefa00e6545213e5c1f1500d6'});
    final response = await http.get(url);
    List<ApiPeliculas> apisPeliculas = [];
    if (response.statusCode == 200) {
      String info = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(info);
      int countPeliculas = 1;

      for (var item in jsonData['results']) {
        var idPelicula = item['id'];
        String titulo = item['original_title'];
        String descripcion = item['overview'];
        String urlPortada =
            'https://image.tmdb.org/t/p/w500/${item['poster_path']}';
        num vote = item['vote_average'].round() * 10;
        apisPeliculas.add(
          ApiPeliculas(idPelicula, countPeliculas, titulo, descripcion,
              urlPortada, vote.toInt()),
        );
        countPeliculas++;
      }

      return apisPeliculas;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listaApiPeliculas = _getApiPeliculas();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(248, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Builder(
              builder: (context) => Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
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
                            Icons.dehaze,
                            size: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Top Rated',
                            style: GoogleFonts.baloo2(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
                accountName: Text(
                  "Aldo Barreto",
                  style: GoogleFonts.baloo2(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                  ),
                ),
                accountEmail: Text(
                  "aldo.pittol@gmail.com",
                  style: GoogleFonts.baloo2(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                    ),
                  ),
                ),
                currentAccountPicture: Image.asset("assets/img/themoviedb.png"),
              ),
              ListTile(
                leading: const Icon(
                  Icons.stars,
                ),
                title: Text(
                  'Popular',
                  style: GoogleFonts.baloo2(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const FeedViewPopular()),
                      (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.star,
                ),
                title: Text(
                  'Top Rated',
                  style: GoogleFonts.baloo2(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.queue_play_next,
                ),
                title: Text(
                  'Upcoming',
                  style: GoogleFonts.baloo2(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const FeedViewUpcoming()),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: _listaApiPeliculas,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: _listApiPeliculasColumn1(snapshot.data),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _listApiPeliculasColumn2(snapshot.data),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Text('Error');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listApiPeliculasColumn1(data) {
    List<Widget> apisPeliculas = [];
    for (var api in data) {
      if (api.count.isEven == false) {
        apisPeliculas.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                RutasAnimationPeliculas(
                  child: Detalle(api.id, api.titulo, api.vote, api.url),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 26),
              height: 218,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(api.url), fit: BoxFit.fill),
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
                        children: [
                          Text(
                            api.titulo,
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
                            '${api.vote}% User Score',
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
    }
    return apisPeliculas;
  }

  List<Widget> _listApiPeliculasColumn2(data) {
    List<Widget> apisPeliculas = [];
    double topMargin = 0;
    for (var api in data) {
      if (api.count.isEven) {
        if (api.count == 2) {
          topMargin = 30;
        } else {
          topMargin = 0;
        }
        apisPeliculas.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                RutasAnimationPeliculas(
                  child: Detalle(api.id, api.titulo, api.vote, api.url),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 26.0,
                top: topMargin,
              ),
              height: 218,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(api.url), fit: BoxFit.fill),
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
                        children: [
                          Text(
                            api.titulo,
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
                            '${api.vote}% User Score',
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
    }
    return apisPeliculas;
  }
}
