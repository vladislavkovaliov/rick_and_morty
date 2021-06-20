import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/usecases/get_all_persons.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_state.dart';

const SERVER_FAILURE = "Server Failure";
const CACHE_FAILURE = "Cache Failure";

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;

  int page = 1;

  PersonListCubit({
    required this.getAllPersons,
  }) : super(PersonEmpty());

  void loadPerson() async {
    if (state is PersonLoading) return;

    final currentState = state;

    var oldPerson = <PersonEntity>[];

    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));

    failureOrPerson.fold(
      (failure) => emit(PersonError(message: _mapFailureToMessage(failure))),
      (character) {
        page++;
        final persons = (state as PersonLoading).oldPersonsList;
        persons.addAll(character);

        emit(PersonLoaded(persons));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        {
          return SERVER_FAILURE;
        }
      case CacheFailure:
        {
          return CACHE_FAILURE;
        }
      default:
        {
          return "Unexpected Error";
        }
    }
  }
}
