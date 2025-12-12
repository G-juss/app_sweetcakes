class CarritoItem {
  final String id;
  final String nombre;
  final double precio;
  final String imagenUrl;
  final int cantidad;

  CarritoItem({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagenUrl,
    required this.cantidad,
  });

  factory CarritoItem.fromMap(Map<String, dynamic> map) {
    return CarritoItem(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      precio: (map['precio'] ?? 0).toDouble(),
      imagenUrl: map['imagenUrl'] ?? '',
      cantidad: map['cantidad'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'imagenUrl': imagenUrl,
      'cantidad': cantidad,
    };
  }
}
