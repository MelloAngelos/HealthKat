import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          Icon(Icons.search),
          SizedBox(width: 8.0,),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search'
              ),
              onSubmitted: (_) => Navigator.of(context).pushNamed('/Discover'),
              style: TextStyle(
                color: Colors.green[900],
              )
          ),
          )
        ],
      ),
    );
  }
}