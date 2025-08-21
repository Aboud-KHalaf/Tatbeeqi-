import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/features/todo/domain/entities/todo_entity.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/empty_today_tasks_widget.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/today_tasks_list_view_item_widget.dart';

class ToDayTasksListViewWidget extends StatefulWidget {
  const ToDayTasksListViewWidget({super.key, required this.toDayToDos});
  final List<ToDoEntity> toDayToDos;
  
  @override
  State<ToDayTasksListViewWidget> createState() => _ToDayTasksListViewWidgetState();
}

class _ToDayTasksListViewWidgetState extends State<ToDayTasksListViewWidget>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _itemAnimations;
  late List<Animation<Offset>> _slideAnimations;
  
  @override
  void initState() {
    super.initState();
    
    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _initializeItemAnimations();
    _startStaggeredAnimations();
  }
  
  void _initializeItemAnimations() {
    _itemControllers = List.generate(
      widget.toDayToDos.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );
    
    _itemAnimations = _itemControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();
    
    _slideAnimations = _itemControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();
  }
  
  void _startStaggeredAnimations() {
    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _itemControllers[i].forward();
        }
      });
    }
  }
  
  @override
  void dispose() {
    _listController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.toDayToDos.isEmpty) {
      return const EmptyToDayTasksWidget();
    }

    return MediaQuery.removePadding(
      removeBottom: true,
      context: context,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.toDayToDos.length,
        itemBuilder: (context, index) {
          final task = widget.toDayToDos[index];
          
          if (index >= _itemAnimations.length) {
            return _buildTaskItem(context, task, index, null, null);
          }
          
          return AnimatedBuilder(
            animation: _itemAnimations[index],
            builder: (context, child) {
              return FadeTransition(
                opacity: _itemAnimations[index],
                child: SlideTransition(
                  position: _slideAnimations[index],
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * _itemAnimations[index].value),
                    child: child,
                  ),
                ),
              );
            },
            child: _buildTaskItem(context, task, index, _itemAnimations[index], _slideAnimations[index]),
          );
        },
      ),
    );
  }
  
  Widget _buildTaskItem(
    BuildContext context,
    ToDoEntity task,
    int index,
    Animation<double>? fadeAnimation,
    Animation<Offset>? slideAnimation,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.only(
            bottom: 8.0,
            left: 20 * (1 - value),
            right: 20 * (1 - value),
          ),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _animateTaskTap(index);
        },
        child: ToDayTaskListViewItemWidget(task: task),
      ),
    );
  }
  
  void _animateTaskTap(int index) {
    if (index < _itemControllers.length) {
      _itemControllers[index].reverse().then((_) {
        _itemControllers[index].forward();
      });
    }
  }
}
