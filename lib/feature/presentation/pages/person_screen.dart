import 'package:flutter/material.dart';
import 'package:rick_and_morty/feature/presentation/widgets/persons_list_widget.dart';

class PersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person'),
        centerTitle: true,
      ),
      body: Container(
        child: Text('persons'),
      ),
    );
  }
}
