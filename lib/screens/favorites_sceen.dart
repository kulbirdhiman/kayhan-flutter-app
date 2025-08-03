import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListPage(),
    );
  }
}

// Model class for a Todo item
class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'N/A',
      completed: json['completed'] ?? false,
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  Future<List<Todo>>? futureTodos;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    setState(() {
      futureTodos = fetchTodos();
    });
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/todos',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'FlutterApp/1.0',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching todos: $e');
    }
  }

  Future<void> _refresh() async {
    _loadTodos();
    await futureTodos; // wait for reload to complete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: futureTodos == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Todo>>(
                future: futureTodos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadTodos,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No todos found'));
                  }

                  final todos = snapshot.data!;
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: todos.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(child: Text(todo.id.toString())),
                        title: Text(todo.title),
                        subtitle:
                            Text(todo.completed ? 'Completed' : 'Pending'),
                        trailing: Icon(
                          todo.completed ? Icons.check_circle : Icons.pending,
                          color: todo.completed ? Colors.green : Colors.orange,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
