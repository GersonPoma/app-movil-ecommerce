import 'package:dartz/dartz.dart';
import 'package:piiicks/core/error/failures.dart';
import 'package:piiicks/core/usecases/usecase.dart';
import 'package:piiicks/domain/entities/cart/cart_item.dart';
import 'package:piiicks/domain/repositories/cart_repository.dart';

class UpdateCartItemUseCase implements UseCase<bool, CartItem> {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CartItem params) async {
    return await repository.updateCartItem(params);
  }
}
