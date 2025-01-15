import 'package:education_app/core/common/usecases/usecases.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._authRepo);
  final AuthRepo _authRepo;

  @override
  ResultFuture<void> call(UpdateUserParams params) => _authRepo.updateUser(
        action: params.action,
        userData: params.userData,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.action,
    required this.userData,
  });

  const UpdateUserParams.empty()
      : action = UpdateUserAction.email,
        userData = '';

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [
        action,
        userData,
      ];
}
