class ItemModel {
  final String id;
  String nombre;
  String descripcion;
  String categoria;
  DateTime fechaCreacion;

  ItemModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.fechaCreacion,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      categoria: json['categoria'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }
}
