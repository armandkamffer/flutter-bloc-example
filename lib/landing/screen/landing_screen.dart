import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_demo/landing/bloc/landing_bloc.dart';
import 'package:flutter_bloc_demo/landing/models/landing_item.dart';

class LandingWidget extends StatefulWidget {
  final LandingBloc? landingBloc;

  const LandingWidget({super.key, this.landingBloc});

  @override
  State<LandingWidget> createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget> {
  late final LandingBloc _landingBloc;

  @override
  initState() {
    super.initState();
    _landingBloc = widget.landingBloc ?? LandingBloc();
  }

  _addItem() {
    var item = LandingItem(title: "New item ${Random().nextInt(100)}");
    _landingBloc.add(LandingAddItem(item: item));
  }

  _removeItem({required LandingItem item}) {
    _landingBloc.add(LandingRemoveItem(item: item));
  }

  _retry() {
    _landingBloc.add(LandingLoadItems());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _landingBloc..add(LandingLoadItems()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("BLoC Demo App"),
        ),
        body: BlocConsumer<LandingBloc, LandingState>(
          listener: (context, state) {
            if (state is LandingLoaded) {
              var message = state.message;
              if (message != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is LandingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LandingLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.items.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    "${index + 1} - ${state.items[index].title}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeItem(item: state.items[index]),
                  ),
                ),
              );
            }
            if (state is LandingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text("Try again"),
                    ),
                  ],
                ),
              );
            }
            return const Text("Empty state");
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addItem(),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
