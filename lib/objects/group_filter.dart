import 'package:firebase_database/firebase_database.dart';
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
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
      label: Text(widget.name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: isSelected ? Color.fromRGBO(255, 255, 255, 0.6) : Color.fromRGBO(0, 0, 0, 0.6),
        ),
      ),
      selected: isSelected,
      side: BorderSide(color: Colors.transparent),
      checkmarkColor: Color.fromRGBO(233, 235, 247, 1),
      backgroundColor: const Color.fromRGBO(233, 235, 247, 1),
      selectedColor: Color.fromRGBO(84, 104, 251, 1),
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