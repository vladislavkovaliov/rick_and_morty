import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:rick_and_morty/feature/presentation/widgets/person_card_widget.dart';

class PersonSearch extends SearchDelegate {
  PersonSearchBloc searchBloc;

  PersonSearch({
    required this.searchBloc,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(SearchPersons(personQuery: query));
    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
        builder: (context, state) {
      List<PersonEntity> persons = [];
      if (state is PersonSearchError) {
        return Text(
          state.message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        );
      } else if (state is PersonSearchLoading) {
        return _loadingIndicator();
      } else if (state is PersonSearchLoaded) {
        persons = state.persons;
      }

      return ListView.separated(
          itemBuilder: (context, int index) {
            if (index < persons.length) {
              return PersonCard(person: persons[index]);
            } else {
              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, int index) =>
              Divider(color: Colors.grey[400]),
          itemCount: persons.length);
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchBloc.add(SearchPersons(personQuery: query));
    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
        builder: (context, state) {
      List<PersonEntity> persons = [];
      if (state is PersonSearchError) {
        return Text(
          state.message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        );
      } else if (state is PersonSearchLoading) {
        return _loadingIndicator();
      } else if (state is PersonSearchLoaded) {
        persons = state.persons;
      }

      return ListView.separated(
          itemBuilder: (context, int index) {
            if (index < persons.length) {
              return PersonCard(person: persons[index]);
            } else {
              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, int index) =>
              Divider(color: Colors.grey[400]),
          itemCount: persons.length);
    });
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
