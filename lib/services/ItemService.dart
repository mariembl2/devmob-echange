import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/item.dart';

class ItemService {
  final CollectionReference _itemCollection =
      FirebaseFirestore.instance.collection('items');

  /// Ajouter un nouvel item
  Future<void> addItem(ItemModel item) async {
    await _itemCollection.add(item.toMap());
  }

  /// Récupérer la liste des items
  Stream<List<ItemModel>> getItems() {
    return _itemCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ItemModel.fromMap(data, doc.id);
            }).toList());
  }

  /// Supprimer un item
  Future<void> deleteItem(String itemID) async {
    await _itemCollection.doc(itemID).delete();
  }

  /// Mettre à jour un item
  Future<void> updateItem(String itemID, Map<String, dynamic> updatedData) async {
    await _itemCollection.doc(itemID).update(updatedData);
  }

  /// Récupérer les items par utilisateur (propriétaire)
  Stream<List<ItemModel>> getItemsByOwner(String ownerID) {
    return _itemCollection
        .where('ownerId', isEqualTo: ownerID)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ItemModel.fromMap(data, doc.id);
            }).toList());
  }
}
