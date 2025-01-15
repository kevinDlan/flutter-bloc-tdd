import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/errors/exceptions.dart';
import 'package:education_app/errors/failure.dart';
import 'package:education_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/features/auth/data/models/user_model.dart';
import 'package:education_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource dataSource;
  late AuthRepoImpl repository;

  setUp(() {
    dataSource = MockAuthRemoteDataSource();
    repository = AuthRepoImpl(dataSource);
    registerFallbackValue(UpdateUserAction.password);
  });

  const tEmail = 'email';
  const tPassword = 'password';
  const tFullName = 'fullName';

  group('forgotPassword', () {
    test(
      'should call [RemoteDataSource.forgotPassword] and complete successfully',
      () async {
        when(() => dataSource.forgotPassword(any()))
            .thenAnswer((_) async => Future.value());

        final result = await repository.forgotPassword(tEmail);

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => dataSource.forgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    test(
      'should return [ServerFailure] when [RemoteDataSource.forgotPassword] '
      ' throws [ServerException]',
      () async {
        when(() => dataSource.forgotPassword(any())).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: 404,
          ),
        );

        final result = await repository.forgotPassword(tEmail);

        expect(
          result,
          equals(
            Left<Failure, void>(
              ServerFailure(message: 'User does not exist', statusCode: 404),
            ),
          ),
        );

        verify(() => dataSource.forgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });

  group('signIn', () {
    test('should call [RemoteData.signIn] and complete successfully', () async {
      when(
        () => dataSource.signIn(
          email: any(named: tEmail),
          password: any(named: tPassword),
        ),
      ).thenAnswer((_) async => const UserModel.empty());

      final result =
          await repository.signIn(email: tEmail, password: tPassword);

      expect(
        result,
        equals(const Right<dynamic, UserModel>(UserModel.empty())),
      );

      verify(() => dataSource.signIn(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test(
      'should return [ServerException] when [RemoteDataSource.signIn] fail',
      () async {
        when(
          () => dataSource.signIn(
            email: any(named: tEmail),
            password: any(named: tPassword),
          ),
        ).thenThrow(
          const ServerException(message: 'Invalide datas', statusCode: 404),
        );

        final result =
            await repository.signIn(email: tEmail, password: tPassword);

        expect(
          result,
          equals(
            Left<Failure, void>(
              ServerFailure(message: 'Invalide datas', statusCode: 404),
            ),
          ),
        );

        verify(() => dataSource.signIn(email: tEmail, password: tPassword))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });

  group('signUp', () {
    test(
      'should call [RemoteDataSource.signUp] and complete successfully',
      () async {
        when(
          () => dataSource.signUp(
            email: any(named: tEmail),
            password: tPassword,
            fullName: tFullName,
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => dataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
        ).called(1);

        verifyNoMoreInteractions(dataSource);
      },
    );

    test(
      'return [ServerException] when [RemoteDataSource.signUp] fail',
      () async {
        when(
          () => dataSource.signUp(
            email: any(named: tEmail),
            password: any(named: tPassword),
            fullName: any(named: tFullName),
          ),
        ).thenThrow(
          const ServerException(
            message: 'email or password already exist',
            statusCode: 409,
          ),
        );

        final result = await repository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        expect(
          result,
          equals(
            Left<ServerFailure, void>(
              ServerFailure(
                message: 'email or password already exist',
                statusCode: 409,
              ),
            ),
          ),
        );
        verify(
          () => dataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });

  group('updateUser', () {
    test(
      'should call [RemoteDataSource.updateUser] and complete successfully',
      () async {
        when(
          () => dataSource.updateUser(
            action: any(named: 'action'),
            userData: any<dynamic>(named: 'userData'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repository.updateUser(
          action: UpdateUserAction.password,
          userData: tPassword,
        );

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => dataSource.updateUser(
            action: UpdateUserAction.password,
            userData: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    test(
      'should return [ServerException] when [RemoteDataSource.updateUser] fail',
      () async {
        when(
          () => dataSource.updateUser(
            action: any(named: 'action'),
            userData: any<dynamic>(named: 'userData'),
          ),
        ).thenThrow(
          const ServerException(message: 'user not found', statusCode: 404),
        );

        final result = await repository.updateUser(
          action: UpdateUserAction.password,
          userData: tPassword,
        );

        expect(
          result,
          equals(
            Left<ServerFailure, void>(
              ServerFailure(message: 'user not found', statusCode: 404),
            ),
          ),
        );
        verify(
          () => dataSource.updateUser(
            action: UpdateUserAction.password,
            userData: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });
}
