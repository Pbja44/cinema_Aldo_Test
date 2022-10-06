class ApiPeliculas {
  int id = 0;
  int count = 0;
  String titulo = '';
  String descripcion = '';
  String url = '';
  num vote = 0.0;

  ApiPeliculas(id, count, titulo, descripcion, url, vote) {
    this.id = id;
    this.count = count;
    this.titulo = titulo;
    this.descripcion = descripcion;
    this.url = url;
    this.vote = vote;
  }
}
