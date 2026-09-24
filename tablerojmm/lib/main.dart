import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tablero de Tareas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const ListaVivaPage(title: 'Tareas chidas'),
    );
  }
}

class Tarea {
  String nombre;
  bool completada;

  Tarea({
    required this.nombre,
    this.completada = false,
  });
}

class ListaVivaPage extends StatefulWidget {
  const ListaVivaPage({super.key, required this.title});

  final String title;

  @override
  State<ListaVivaPage> createState() => _ListaVivaPageState();
}

class _ListaVivaPageState extends State<ListaVivaPage> {
  final List<Tarea> _tareas = [
    Tarea(nombre: 'Bañar al tyson'),
    Tarea(nombre: 'Bañar al kayser'),
    Tarea(nombre: 'Bañar a rocko'),
    Tarea(nombre: 'Bañarme yo'),
  ];
  bool _soloPendientes = false;


  List<Tarea> get _tareasVisibles {
    if (_soloPendientes) {
      return _tareas.where((tarea) => !tarea.completada).toList();
    }

    return _tareas;
  }

  int get _completadas {
    return _tareas.where((tarea) => tarea.completada).length;
  }

  void _cambiarEstado(Tarea tarea) {
    setState(() {
      tarea.completada = !tarea.completada;
    });
  }

  void _agregar() {
    setState(() {
      _tareas.add(
        Tarea(nombre: 'Tarea ${_tareas.length + 1}'),
      );
    });
  }

  void _eliminar(Tarea tarea) {
    setState(() {
      _tareas.remove(tarea);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completadas: $_completadas / ${_tareas.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Text('Solo pendientes'),
                const SizedBox(width: 8),
                Switch(
                  value: _soloPendientes,
                  onChanged: (valor) {
                    setState(() {
                      _soloPendientes = valor;
                    });
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: _tareasVisibles.isEmpty
                ? const Center(
              child: Text(
                'No hay tareas pendientes',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _tareasVisibles.length,
              itemBuilder: (context, index) {
                final tarea = _tareasVisibles[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: (valor) {
                        _cambiarEstado(tarea);
                      },
                    ),
                    title: Text(
                      tarea.nombre,
                      style: TextStyle(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: tarea.completada
                            ? Colors.pink
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Eliminar',
                      onPressed: () {
                        _eliminar(tarea);
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}