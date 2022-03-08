import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/edit_todo_cubit.dart';
import 'package:todo_app/data/models/todo.dart';

class EditTodoScreen extends StatelessWidget {
  final Todo todo;
  EditTodoScreen({Key? key, required this.todo}) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = todo.todoMessage;
    return BlocListener<EditTodoCubit, EditTodoState>(
      listener: (context, state) {
        if (state is TodoEdited) {
          Navigator.pop(context);
        } else if (state is EditTodoError) {
          final snackBar = SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.redAccent,
              content: Text(
                state.error,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Todo'),
          actions: [
            InkWell(
              onTap: () {
                BlocProvider.of<EditTodoCubit>(context).deleteTodo(todo);
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.delete),
              ),
            ),
          ],
        ),
        body: _body(context),
      ),
    );
  }

  Widget _body(context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: _controller,
            decoration:
                const InputDecoration(hintText: 'Enter todo message...'),
          ),
          const SizedBox(height: 10.0),
          InkWell(
            onTap: () {
              BlocProvider.of<EditTodoCubit>(context)
                  .updateTodo(todo, _controller.text);
            },
            child: _updateButton(context),
          ),
        ],
      ),
    );
  }

  Widget _updateButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: BlocBuilder<EditTodoCubit, EditTodoState>(
          builder: (context, state) {
            if (state is TodoEditing) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Text(
              'Update Todo',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
