import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  bool _isLoading = true;
  bool _isDeletingSelected = false;
  final Set<String> _selectedTaskIds = <String>{};

  bool get _isSelectionMode => _selectedTaskIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _taskService.getTasks();
      if (!mounted) return;
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi load tasks: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleTaskSelection(String taskId) {
    setState(() {
      if (_selectedTaskIds.contains(taskId)) {
        _selectedTaskIds.remove(taskId);
      } else {
        _selectedTaskIds.add(taskId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedTaskIds.clear();
    });
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await _taskService.deleteTask(task.id);
      if (!mounted) return;

      setState(() {
        _tasks.removeWhere((item) => item.id == task.id);
        _selectedTaskIds.remove(task.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa task: ${task.title}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi xóa task: $e')),
      );
    }
  }

  Future<void> _deleteSelectedTasks() async {
    if (_selectedTaskIds.isEmpty || _isDeletingSelected) return;

    final idsToDelete = Set<String>.from(_selectedTaskIds);
    final deletedIds = <String>{};

    setState(() {
      _isDeletingSelected = true;
    });

    for (final id in idsToDelete) {
      try {
        await _taskService.deleteTask(id);
        deletedIds.add(id);
      } catch (_) {
        // Keep going so the user can still delete other selected tasks.
      }
    }

    if (!mounted) return;

    setState(() {
      _tasks.removeWhere((task) => deletedIds.contains(task.id));
      _selectedTaskIds.removeAll(deletedIds);
      _isDeletingSelected = false;
    });

    final failedCount = idsToDelete.length - deletedIds.length;
    final message = failedCount == 0
        ? 'Đã xóa ${deletedIds.length} task đã chọn'
        : 'Đã xóa ${deletedIds.length} task, lỗi $failedCount task';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
        title: Text(
          _isSelectionMode
              ? 'Đã chọn ${_selectedTaskIds.length} task'
              : 'Task List - Nguyễn Bình Minh - 6451071047',
        ),
        actions: _isSelectionMode
            ? [
                IconButton(
                  onPressed: _isDeletingSelected ? null : _deleteSelectedTasks,
                  icon: _isDeletingSelected
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete),
                  tooltip: 'Xóa các task đã chọn',
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('Không có task nào'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final isSelected = _selectedTaskIds.contains(task.id);

                    return Dismissible(
                      key: Key(task.id),
                      direction: _isSelectionMode
                          ? DismissDirection.none
                          : DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) => _deleteTask(task),
                      child: ListTile(
                        onTap: () => _toggleTaskSelection(task.id),
                        selected: isSelected,
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggleTaskSelection(task.id),
                        ),
                        title: Text(task.title),
                        subtitle: Text(
                          'ID: ${task.id} - ${task.done ? 'Hoàn thành' : 'Chưa hoàn thành'}',
                        ),
                        trailing: _isSelectionMode
                            ? null
                            : IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(task),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}