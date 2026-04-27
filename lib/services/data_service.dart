import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';

class DataService {
  static const String _keyItems = 'items_list';

  Future<List<ItemModel>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyItems);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => ItemModel.fromJson(e)).toList();
  }

  Future<void> saveItem(ItemModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getItems();
    items.add(item);
    await prefs.setString(_keyItems, json.encode(items.map((e) => e.toJson()).toList()));
  }

  Future<void> updateItem(ItemModel updated) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getItems();
    final index = items.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      items[index] = updated;
      await prefs.setString(_keyItems, json.encode(items.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> deleteItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getItems();
    items.removeWhere((e) => e.id == id);
    await prefs.setString(_keyItems, json.encode(items.map((e) => e.toJson()).toList()));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyItems);
  }
}
