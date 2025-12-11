class Postre {
  final String? id; // Puede ser nulo al crearlo, Firebase le asignará uno
  final String nombre;
  final String imagenUrl;
  final double precio;
  final int stock; 

  Postre({
    this.id,
    required this.nombre,
    required this.imagenUrl,
    required this.precio,
    required this.stock,
  });

  // Convertir datos de Firebase a un Objeto Dart
  factory Postre.fromMap(Map<String, dynamic> map, String documentId) {
    return Postre(
      id: documentId,
      nombre: map['nombre'] ?? '',
      imagenUrl: map['imagenUrl'] ?? '',
      precio: (map['precio'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
    );
  }

  // Convertir Objeto Dart a Mapa para enviar a Firebase
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagenUrl': imagenUrl,
      'precio': precio,
      'stock': stock,
    };
  }
}