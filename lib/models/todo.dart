class Todo {
  
  Todo({required this.title, required this.dateTime});

  String title;
  DateTime dateTime;

  //PEGAR O JSON E TRANSFORMAR EM TODO
  Todo.fromJson(Map<String, dynamic> json)
  :title = json['title'],
  dateTime = DateTime.parse(json['dateTime']);


  //PEGA O TIPO TODO E TRANSFORMA E JSON
  Map<String, dynamic> toJson() {
    return {
      'title':title,
      'dateTime': dateTime.toIso8601String()
    };

  }
}