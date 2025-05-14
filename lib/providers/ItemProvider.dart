// lib/providers/itemprovider.dart
import 'package:flutter/material.dart';
import 'package:dev_mob/models/item_model.dart';
import 'package:dev_mob/services/itemservice.dart';

class ItemProvider with ChangeNotifier {
  final ItemService _itemService = ItemService();

  List<ItemModel> _items = [];
  List<ItemModel> get items => _items;

  ItemProvider() {
    _fetchItems();
  }

  void _fetchItems() {
    _itemService.getItems().listen((fetchedItems) {
      _items = fetchedItems;
      notifyListeners(); // notifie les widgets quand la liste change
    });
  }

  Future<void> addItem(ItemModel item) async {
    await _itemService.addItem(item);
  }

  Future<void> deleteItem(String itemId) async {
    await _itemService.deleteItem(itemId);
  }
}
