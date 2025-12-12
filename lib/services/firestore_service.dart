import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/postre.dart';
import '../models/carrito_item.dart';

// Servicio para interactuar con la base de datos
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- PRODUCTOS (Público) ---
  final CollectionReference _productosRef =
      FirebaseFirestore.instance.collection('productos');

  Stream<List<Postre>> getProductos() {
    return _productosRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Postre.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addProducto(Postre postre) => _productosRef.add(postre.toMap());

  Future<void> updateProducto(Postre postre) =>
      _productosRef.doc(postre.id).update(postre.toMap());

  Future<void> deleteProducto(String id) => _productosRef.doc(id).delete();

  // --- CARRITO (Privado por usuario) ---
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _miCarritoRef() {
    final uid = _userId;
    if (uid == null) throw Exception("Usuario no autenticado");
    return _db.collection('usuarios').doc(uid).collection('carrito');
  }

  CollectionReference<Map<String, dynamic>> _misPedidosRef() {
    final uid = _userId;
    if (uid == null) throw Exception("Usuario no autenticado");
    return _db.collection('usuarios').doc(uid).collection('pedidos');
  }

  // 1) Agregar al carrito
  Future<void> agregarAlCarrito(Postre postre) async {
    final uid = _userId;
    if (uid == null) return;

    final idProducto = postre.id;
    if (idProducto == null || idProducto.isEmpty) {
      throw Exception("postre.id es null/empty");
    }

    final docRef = _miCarritoRef().doc(idProducto);
    final snap = await docRef.get();

    if (snap.exists) {
      await docRef.update({'cantidad': FieldValue.increment(1)});
    } else {
      final item = CarritoItem(
        id: idProducto,
        nombre: postre.nombre,
        precio: postre.precio,
        imagenUrl: postre.imagenUrl,
        cantidad: 1,
      );
      await docRef.set(item.toMap());
    }
  }

  // 2) Leer carrito
  Stream<List<CarritoItem>> getCarrito() {
    if (_userId == null) return Stream.value([]);

    return _miCarritoRef().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CarritoItem.fromMap(doc.data());
      }).toList();
    });
  }

  // 3) +
  Future<void> incrementarCantidad(String productoId) async {
    if (_userId == null) return;
    await _miCarritoRef().doc(productoId).update({
      'cantidad': FieldValue.increment(1),
    });
  }

  // 4) -
  Future<void> decrementarCantidad(String productoId) async {
    if (_userId == null) return;

    final docRef = _miCarritoRef().doc(productoId);
    final snap = await docRef.get();
    if (!snap.exists) return;

    final actual = (snap.data()?['cantidad'] ?? 1) as int;

    if (actual <= 1) {
      await docRef.delete();
    } else {
      await docRef.update({'cantidad': actual - 1});
    }
  }

  // 5) eliminar
  Future<void> eliminarDelCarrito(String productoId) async {
    if (_userId == null) return;
    await _miCarritoRef().doc(productoId).delete();
  }

  // 6) confirmar pedido (simulado)
  Future<void> confirmarPedido() async {
    if (_userId == null) return;

    final carritoSnap = await _miCarritoRef().get();
    if (carritoSnap.docs.isEmpty) return;

    final items = carritoSnap.docs.map((d) => d.data()).toList();

    final total = items.fold<double>(0, (sum, it) {
      final precio = (it['precio'] ?? 0).toDouble();
      final cantidad = (it['cantidad'] ?? 1) as int;
      return sum + (precio * cantidad);
    });

    await _misPedidosRef().add({
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'confirmado',
      'metodoPago': 'simulado',
      'total': total,
      'items': items,
    });

    // vaciar carrito
    final batch = _db.batch();
    for (final doc in carritoSnap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
