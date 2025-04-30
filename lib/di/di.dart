import 'package:get_it/get_it.dart';
import 'package:piiicks/di/cubits.dart';
import 'package:piiicks/di/order.dart';
import 'package:piiicks/di/product.dart';
import 'package:piiicks/di/user.dart';
import 'cart.dart';
import 'category.dart';
import 'common.dart';
import 'delivery.dart';

final sl = GetIt.instance;

// Main Initialization
Future<void> init() async {
  // 1️⃣ Primero las dependencias base
  registerCommonDependencies();

  // 2️⃣ Luego los Features (Blocs, UseCases, Repositorios, DataSources)
  registerCategoryFeature();
  registerProductFeature();
  registerUserFeature();
  registerDeliveryInfoFeature();
  registerCartFeature();
  registerOrderFeature();

  // 3️⃣ Finalmente los Cubits generales
  registerCubits();
}
