import 'package:flutter/material.dart';

class GroupFilter extends StatefulWidget{
  String id = '';
  String name = '';
  var filters = [];

  GroupFilter(this.id, this.name, this.filters);

  @override
  State<GroupFilter> createState() => _GroupFilterState();
}

class _GroupFilterState extends State<GroupFilter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.filters.contains(widget.id);
    return FilterChip(
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 4),
      label: Text(widget.name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: const Color.fromRGBO(235, 235, 235, 0.8)
        ),
      ),
      selected: isSelected,
      side: const BorderSide(color: Color.fromRGBO(32, 35, 43, 1),),
      checkmarkColor: const Color.fromRGBO(233, 235, 247, 1),
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      selectedColor: const Color.fromRGBO(98, 112, 242, 1),
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            AddGroup(true).dispatch(context);
          } else {
            RemoveGroup(true).dispatch(context);
          }
        });
      },
    );
  }
}

class AddGroup extends Notification {
  final bool val;
  AddGroup(this.val);
}

class RemoveGroup extends Notification {
  final bool val;
  RemoveGroup(this.val);
}