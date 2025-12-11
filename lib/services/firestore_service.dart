import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/postre.dart';

// Servicio para interactuar con la base de datos
class FirestoreService {
  // Referencia a la colección "productos" en la base de datos
  final CollectionReference _productosRef = 
      FirebaseFirestore.instance.collection('productos');

  // 1. LEER (Stream): Mantiene el catálogo y admin actualizados en tiempo real
  Stream<List<Postre>> getProductos() {
    return _productosRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Postre.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 2. AGREGAR
  Future<void> addProducto(Postre postre) {
    return _productosRef.add(postre.toMap());
  }

  // 3. ACTUALIZAR (Editar nombre, precio, stock)
  Future<void> updateProducto(Postre postre) {
    return _productosRef.doc(postre.id).update(postre.toMap());
  }

  // 4. ELIMINAR
  Future<void> deleteProducto(String id) {
    return _productosRef.doc(id).delete();
  }
}