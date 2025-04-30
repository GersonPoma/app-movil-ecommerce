import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repositories/cart_repository.dart';

class DeleteCartItemUseCase implements UseCase<bool, String> {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String cartItemId) {
    return repository.deleteFromCart(cartItemId);
  }
}
