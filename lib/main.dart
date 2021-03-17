import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_safe/bloc/counter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLOC Safe Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: BlocProvider(
        create: (context) => CounterBloc(0),
        child: BlocSafeHomePage(),
      ),
    );
  }
}

class BlocSafeHomePage extends StatelessWidget {
  void _addEvent(BuildContext context, CounterEvent event) {
    context.read<CounterBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("BLoC Safe demo"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  "${state.count}",
                  style: Theme.of(context).textTheme.headline4,
                ),
                if (state is CounterIncremented)
                  Text(
                    "You have done ${state.consecutivesAdditionsOperations} consecutives increment operations",
                  ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is CounterIncremented)
                FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  onPressed: () => _addEvent(context, DecrementCounter()),
                  tooltip: 'Decrement',
                  child: Icon(Icons.exposure_minus_1),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  onPressed: () => _addEvent(context, IncrementCounter()),
                  tooltip: 'Increment',
                  child: Icon(Icons.plus_one),
                ),
              ),
            ],
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
