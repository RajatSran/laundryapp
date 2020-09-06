import 'package:flutter/foundation.dart';
import './lostproduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<LostProduct> _items = [];
  List<LostProduct> get items {
    return [..._items];
  }

  Future<void> fetchandsetproducts() async {
    const url = 'https://nulaundry-a4c31.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<LostProduct> loadedproducts = [];
      extractedData.forEach((key, value) {
        loadedproducts.add(
          LostProduct(
              id: key,
              title: value['title'],
              description: value['description'],
              imageurl: value['url']),
        );
      });
      _items = loadedproducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> additem(
      String pickedtitle, String pickeddescription, String pickedurl) async {
    const url = 'https://nulaundry-a4c31.firebaseio.com/products.json';
    try {
      final value = await http.post(
        url,
        body: json.encode({
          'id': DateTime.now().toString(),
          'title': pickedtitle,
          'description': pickeddescription,
          'url': pickedurl,
        }),
      );
      final newitem = LostProduct(
        id: json.decode(value.body)['products'],
        title: pickedtitle,
        description: pickeddescription,
        imageurl: pickedurl,
      );
      _items.add(newitem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  LostProduct findBy(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // Future<void> deleteProduct(String id) async {
  //   final url = 'https://flutter-update.firebaseio.com/products/$id.json';
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProductIndex];
  //   _items.removeAt(existingProductIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingProduct = null;
  // }

}
