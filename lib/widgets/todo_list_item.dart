import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key, required this.todo, required this.onDelete}) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Slidable(child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.grey[200]),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('dd/MM/yyyy').format(todo.dateTime),
              style: TextStyle(fontSize: 12),
            ),
            Text(
              todo.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ), 
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          caption: 'Deletar',
          onTap: () {
            onDelete(todo);
          },
        ),
      ],)
    );
  }
}
