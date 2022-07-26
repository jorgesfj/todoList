import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';


const todoListKey = 'todo_list';

class TodoRepository {
  
  //criando objeto shared, sem inicializar
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    //instanciar sharedPreferences (com padrao singleton)
    sharedPreferences = await SharedPreferences.getInstance();
    //buscar a String salva
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    //transformar a string em uma lista 
    final List jsonDecoded = json.decode(jsonString) as List;
    //retornar cada objeto da lista como um Todo
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }


  void saveTodoList(List<Todo> todos) {
    //transformar a lista em string
    final String jsonString = json.encode(todos);
    //salvar a string
    sharedPreferences.setString(todoListKey, jsonString);
  }

}
