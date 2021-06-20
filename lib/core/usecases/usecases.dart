import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/core/error/failure.dart';

/// Type - type of returnable value in case if there is no error
/// Params - call changes of code
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}