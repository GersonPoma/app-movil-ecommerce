import 'package:dartz/dartz.dart';
import 'package:piiicks/core/error/failures.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../repositories/user_repository.dart';

class IsTokenAvailableUseCase implements UseCase<bool, NoParams> {
  final UserRepository repository;

  IsTokenAvailableUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final result = await repository.isTokenAvailable();
      return Right(result);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
