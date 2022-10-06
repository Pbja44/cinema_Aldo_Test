class ApiActores {
  int id = 0;
  String nombre = '';
  String biografia = '';
  String urlFoto = '';
  List creditos = [];

  ApiActores(id, nombre, biografia, urlFoto, creditos) {
    this.id = id;
    this.nombre = nombre;
    this.biografia = biografia;
    this.urlFoto = urlFoto;
    this.creditos = creditos;
  }
}
