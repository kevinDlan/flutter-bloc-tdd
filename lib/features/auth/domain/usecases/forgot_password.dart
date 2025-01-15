import 'package:education_app/core/common/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._authRepo);
  final AuthRepo _authRepo;

  @override
  ResultFuture<void> call(String params) => _authRepo.forgotPassword(params);
}
