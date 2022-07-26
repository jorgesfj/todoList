import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  //inicializar a pagina ja buscando as tarefas
  @override
  void initState() {
    super.initState();

    //buscar tarefas, quando retornar adicionar o retorno na lista
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: todoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Adicione uma tarefa',
                      hintText: 'Ex. Estudar',
                      errorText: errorText,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 2
                        )
                      ),
                      labelStyle: TextStyle(
                        color: Colors.green
                      )
                      ),
                )),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    String text = todoController.text;

                    if(text.isEmpty) {
                      setState(() {
                        errorText = 'O titulo não pode ser vazio';
                      });
                      return;
                    }

                    setState(() {
                      Todo newTodo =
                          Todo(title: text, dateTime: DateTime.now());
                      todos.add(newTodo);
                      errorText = null;
                    });
                    todoController.clear();
                    todoRepository.saveTodoList(todos);
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green, padding: EdgeInsets.all(14)),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (Todo todo in todos)
                    TodoListItem(todo: todo, onDelete: onDelete),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Você possui ${todos.length} tarefas pendentes'),
                ),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: showDeleteTodosConfirmationDialog,
                  child: Text('Limpar tudo'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green, padding: EdgeInsets.all(14)),
                )
              ],
            )
          ],
        ),
      )),
    ));
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso!',
        style: TextStyle(color: Color(0xff060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xff00d7f3),
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tudo?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                  style: TextButton.styleFrom(primary: Colors.green),
                ),
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  deleteTodos();
                }, child: Text("Limpa tudo"), style: TextButton.styleFrom(primary: Colors.red),)
              ],
            ));
  }

  void deleteTodos(){
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
