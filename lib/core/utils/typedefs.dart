import 'package:dartz/dartz.dart';
import 'package:education_app/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef DataMap = Map<String, dynamic>;
