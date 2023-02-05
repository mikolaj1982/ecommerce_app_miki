import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastWishListRepo implements LocalCartRepository {
  SembastWishListRepo(this.database);

  final Database database;
  final store = StoreRef.main();
  static const wishListItemsKey = ('wishListItems');

  static Future<Database> openDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      return await databaseFactoryIo.openDatabase('${appDocumentDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastWishListRepo> makeDefault() async {
    return SembastWishListRepo(await openDatabase('wishList.db'));
  }

  @override
  Future<Cart> fetchCart() async {
    debugPrint('fetching cart from sembast repo');
    final cartJson = await store.record(wishListItemsKey).get(database);
    debugPrint('-------------------------');
    debugPrint('cartJson $cartJson');
    if (cartJson == null) {
      return const Cart();
    } else {
      return Cart.fromJson(cartJson.toString());
    }
  }

  Future<void> clear() {
    return store.record(wishListItemsKey).delete(database);
  }

  @override
  Future<void> setCart(Cart cart) async {
    // throw StateError('Connection error');
    await store.record(wishListItemsKey).put(database, cart.toJson());
  }

  @override
  Stream<Cart> watchCart() {
    final record = store.record(wishListItemsKey);
    return record.onSnapshot(database).map((snapshot) {
      if (snapshot != null) {
        return Cart.fromJson(snapshot.value.toString());
      } else {
        return const Cart();
      }
    });
  }
}
