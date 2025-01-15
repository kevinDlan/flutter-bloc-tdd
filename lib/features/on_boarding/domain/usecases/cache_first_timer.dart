import 'package:education_app/core/common/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/features/on_boarding/domain/repositories/on_boarding_repo.dart';

class CacheFirstTimer implements UseCaseWithoutParams<void> {
  const CacheFirstTimer(this._repo);

  final OnBoardingRepo _repo;
  @override
  ResultFuture<void> call() => _repo.cacheFirstTimer();
}
