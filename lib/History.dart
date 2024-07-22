import 'package:calculator/MyHomePage.dart';
import 'package:calculator/historytile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryMenu extends StatefulWidget {
  final Box historyBox;
   HistoryMenu({super.key, required this.historyBox});

  @override
  State<HistoryMenu> createState() => _HistoryMenuState();
}

class _HistoryMenuState extends State<HistoryMenu> {
  Color greyShade = Color(0xFF333333);
  final _historyBox = Hive.box("historyBox");


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(right: BorderSide(width: 1, color: greyShade,)),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                child: ValueListenableBuilder(valueListenable: widget.historyBox.listenable(), builder: (context, value, child) {
                  final List calculations = value.values.toList();
                  return ListView.builder(
                    reverse: true,
                      itemCount: calculations.length,
                      itemBuilder: (context, index) {
                        final calculation =calculations[index];
                        return HistoryTile(abc: calculation.inputExpression,
                          def: calculation.result,
                        );
                      },);
                },),
              ),
            ),
            SizedBox(
              height: 47,
              width: 210,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greyShade,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.only(left: 50, right: 50),
                  ),
                  onPressed:() => _historyBox.clear(),

                  child: Text("Clear History", style: TextStyle(fontSize: 18.5),),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
