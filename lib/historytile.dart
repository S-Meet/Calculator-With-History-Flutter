import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {

  final String abc;
  final String def;

   HistoryTile({
    super.key,
    required this.abc,
    required this.def,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(bottom: 25,right: 10),
      child: Column(
        children: [
          SizedBox(height: 5,),
          Text(abc, style: TextStyle(fontSize: 22, color: Colors.white),),
          SizedBox(height: 7.5,),
          Text(("=$def"), style: TextStyle(fontSize: 22, color: Colors.green),),
        ],
      ),
    );
  }
}
