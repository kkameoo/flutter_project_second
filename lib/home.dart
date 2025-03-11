import 'package:flutter/material.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _HomeForm(),
    );
  }
}

class _HomeForm extends StatefulWidget {
  const _HomeForm({super.key});

  @override
  State<_HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<_HomeForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/list");
        },
      ),
    );
  }
}
