import 'package:education_app/errors/exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
      : assert(
          statusCode is String || statusCode is int,
          'Statuscode cannot be ${statusCode.runtimeType}',
        );

  final String message;
  final dynamic statusCode;

  @override
  List<dynamic> get props => [message, statusCode];

  String get errorMessage => message;
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException serverException)
      : this(
          message: serverException.message,
          statusCode: serverException.statusCode,
        );
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, required super.statusCode});
}
