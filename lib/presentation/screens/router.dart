import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/constants/strings.dart';
import 'package:todo_app/cubit/add_todo_cubit.dart';
import 'package:todo_app/cubit/edit_todo_cubit.dart';
import 'package:todo_app/cubit/todos_cubit.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/network_service.dart';
import 'package:todo_app/data/repository.dart';
import 'package:todo_app/presentation/screens/add_todo_screen.dart';
import 'package:todo_app/presentation/screens/edit_todo_screen.dart';
import 'package:todo_app/presentation/screens/todos_screen.dart';

class AppRouter {
  late Repository repository;
  late TodosCubit todosCubit;

  AppRouter() {
    repository = Repository(networkService: NetworkService());
    todosCubit = TodosCubit(repository: repository);
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: todosCubit,
                  child: const TodosScreen(),
                ));
      case EDIT_TODO_ROUTE:
        final todo = settings.arguments as Todo;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => EditTodoCubit(
                      repository: repository, todosCubit: todosCubit),
                  child: EditTodoScreen(todo: todo),
                ));
      case ADD_TODO_ROUTE:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AddTodoCubit(
                      repository: repository, todosCubit: todosCubit),
                  child: AddTodoScreen(),
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Container(
                color: Colors.grey.shade200,
                child: const Text('Error: No Routes Found!'),
              ),
            ),
          ),
        );
    }
  }
}
