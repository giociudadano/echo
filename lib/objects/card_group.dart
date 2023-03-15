import 'package:flutter/material.dart';

class CardGroup extends StatefulWidget {
  var name, desc, admin;
  CardGroup(this.name, this.desc, this.admin);

  @override
  State<CardGroup> createState() => _CardGroupState();
}

class _CardGroupState extends State<CardGroup> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(21, 23, 28, 0)),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Color.fromRGBO(21, 23, 28, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${widget.desc}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Colors.white,
                                    height: 0.85,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 58,
                            child: Text(
                              "by ${widget.admin}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color.fromRGBO(235, 235, 235, 0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          color: Color.fromRGBO(98, 112, 242, 1),
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
