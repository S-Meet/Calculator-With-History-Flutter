import 'package:calculator/History.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class Calc{
  final String inputExpression;
  final String result;

  Calc(this.inputExpression, this.result);
}

final _historyBox = Hive.box("historyBox");

class CalcAdapter extends TypeAdapter{

  @override
  final typeId = 0;

  @override
  Calc read(BinaryReader reader){
    return Calc(
      reader.readString(),
      reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, obj){
    writer.writeString(obj.inputExpression);
    writer.writeString(obj.result);
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  //List of Buttons
  final List<String> buttons = [
  'C',
  '( )',
  '%',
  '/',
  '7',
  '8',
  '9',
  '×',
  '4',
  '5',
  '6',
  '-',
  '1',
  '2',
  '3',
  '+',
  '+/-',
  '0',
  '.',
  '=',
  ];

  Color textColor = Colors.white;
  Color deleteColor = Colors.grey;
  Color greyShade = Color(0xFF333333);
  var inputText = "";
  var outputText = "";
  var liveCalc = "";
  bool showHistoryStatus = false;
  bool isMenuOpen = false;


  void addHistory(String inputExp, String result){
    final calculation = Calc(inputExp, result);
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    _historyBox.put(ts,calculation);
    print('INPUT : $inputExp');
    print('RES : $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.centerRight,
                          child: Text(
                            inputText,
                            style: TextStyle(color: textColor, fontSize: 35),
                          )),
                      Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 24),
                          child: Text(
                            liveCalc,
                            style: TextStyle(color: Colors.grey, fontSize: 22),
                          )),
                    ],
                  ),
                )),
                //Delete Button
                Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 3),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 20, bottom: 8),
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                            icon: isMenuOpen ?
                            ImageIcon(AssetImage('Assets/icons/calculator.png'), size: 25,) :
                            ImageIcon(AssetImage('Assets/icons/three-o-clock-clock.png'), size: 25,),
                            /*Icon(
                              Icons.history,
                              size: 38,
                            ),*/
                            onPressed: () {
                              toggleHistory();
                              setState(() {
                                isMenuOpen = !isMenuOpen;
                              });
                            },
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 13, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  //checking if inputText is already null or not
                                  if (inputText.isNotEmpty) {
                                    inputText = inputText.substring(
                                        0, inputText.length - 1);
                                  }
                                  liveCalc = "";
                                  deleteColorChange();
                                });
                              },
                              child: ImageIcon(
                                AssetImage("Assets/icons/delete.png"),
                                size: 30,
                                color: deleteColor,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: greyShade,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(top: 7.5),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemCount: buttons.length,
                      itemBuilder: (context, index) {
                        //Clear Button
                        if (index == 0) {
                          return calcButtons(
                            userInput: () {
                              setState(() {
                                inputText = "";
                                outputText = "";
                                liveCalc = "";
                                // for changing back to white color after the output
                                textColor = Colors.white;
                                deleteColorChange();
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: Colors.grey[900],
                            textColor: Colors.deepOrange,
                          );

                          //Equal to Button
                        } else if (index == buttons.length - 1) {
                          return calcButtons(
                            userInput: () {
                              setState(() {
                                if (inputText.isNotEmpty) {
                                  equalLogic();
                                }
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: Colors.green,
                            textColor: Colors.white,
                          );
                        }
                        // '+/-' Button
                        else if (index == 16) {
                          return calcButtons(
                            userInput: () {
                              setState(() {
                                toggleSign();
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: Colors.grey[900],
                            textColor: Colors.white,
                          );
                        }
                        //'( )' Button
                        else if (index == 1) {
                          return calcButtons(
                            userInput: () {
                              setState(() {
                                toggleParentheses();
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: greyShade,
                            textColor: Colors.green,
                          );
                        } else if (op(buttons[index])) {
                          return calcButtons(
                            userInput: () {
                              setState(() {
                                handleOperator(buttons[index]);
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: greyShade,
                            textColor: Colors.green,
                          );
                        } else {
                          return calcButtons(
                            userInput: () {
                              setState(() {
                                inputText += buttons[index];
                                showLiveCalc();
                                deleteColorChange();
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: op(buttons[index])
                                ? greyShade
                                : Colors.grey[900],
                            textColor: op(buttons[index])
                                ? Colors.green
                                : Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Positioned will display the History menu on Condition.
            Positioned(bottom: 0,
              left: 0,
              height: MediaQuery.of(context).size.height * 0.59,
              width: MediaQuery.of(context).size.width * 0.75,
              child: showHistoryStatus ? HistoryMenu(historyBox: _historyBox,) : Container(),),
          ]),
        ));
  }

  //It will Change the visibility of the HISTORY menu
  // when user presses the button.
  void toggleHistory() {
    setState(() {
      showHistoryStatus = !showHistoryStatus;
    });
  }

  //Function for having different colors for different buttons
  bool op(String op) {
    if (op == '( )' ||
        op == '%' ||
        op == '/' ||
        op == '×' ||
        op == '-' ||
        op == '+') {
      return true;
    }
    return false;
  }

  //for checking no of opening and closing brackets enter by user are same or not
  bool mismatchParentheses() {
    int count = 0;
    for (int i = 0; i < inputText.length; i++) {
      if (inputText[i] == '(') {
        count++;
      } else if (inputText[i] == ')') {
        count--;
        // if < 0 means more closing than opening
      }
    }
    //displaying SnackBar is inputText encounters miss-match Parentheses
    return count < 0 || count != 0;
  }

  //displaying a snack-bar
  void displaySnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mismatch parentheses!"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  // '+/-' Button Logic
  void toggleSign() {
    setState(() {
      if (inputText.isEmpty) {
        // if inputText is empty and user presses this button
        inputText += '(-';
      } else {
        if (inputText.isNotEmpty && inputText[0] == '-') {
          // Remove the '-' sign if it's the first character
          inputText = inputText.substring(1);
        } else if (inputText.isNotEmpty && inputText[0] != '-') {
          // Add the '-' sign if it's not present at the beginning
          inputText = '-' + inputText;
        }
      }
      showLiveCalc();
      deleteColorChange();
    });
  }

  void toggleParentheses() {
    setState(() {
      //Getting the last char only if inputText is not empty
      String lastChar =
          inputText.isNotEmpty ? inputText.substring(inputText.length - 1) : "";
      Set<String> operators = {
        '+',
        '*',
        '/',
        '-',
        '%',
      };
      if (inputText.isEmpty || inputText == "") {
        // If input text is empty
        inputText += '(';
      } else if ((inputText.contains('(') || inputText.contains('*(')) &&
          !(operators.contains(lastChar))) {
        //check if inputText already has opening brackets and
        // the last char is not a operator, then apply the closing ones
        inputText += ')';
      } else if (inputText.endsWith(')') ||
          RegExp(r'[0-9]$').hasMatch(inputText)) {
        // If input text ends with closing parenthesis or a number, add multiplication and opening parenthesis
        inputText += '*(';
      } else {
        // Otherwise, simply add opening parenthesis
        inputText += '(';
      }
      mismatchParentheses();
      showLiveCalc();
      deleteColorChange();
    });
  }

  void handleOperator(String operator) {
    setState(() {
      if (inputText.isEmpty) {
        // If input text is empty, just add the operator
        inputText += operator;
      } else {
        // Check if the last character in the input is an operator by using
        // substring(staring from length -1)
        String lastChar = inputText.substring(inputText.length - 1);
        if (op(lastChar)) {
          // If the last character is an operator, replace it with the new one
          inputText = inputText.substring(0, inputText.length - 1) + operator;
        } else {
          // Otherwise, just add the new operator
          inputText += operator;
        }
      }
    });
    showLiveCalc();
    deleteColorChange();
  }

  // '=' Button Logic
  void equalLogic() {
    //checks if user has entered correct expression in terms of -
    // -equal opening and closing brackets
    if (mismatchParentheses()) {
      displaySnackbar();
      return;
    }

    //if user enters empty () then it is mathematically (0)
    if (inputText.contains('()')) {
      setState(() {
        inputText = '0';
        outputText = '0';
        textColor = Colors.green;
      });
      return;
    }

    String answer = inputText;
    // because multiplication's logic works in *
    answer = answer.replaceAll('×', '*');

    // % Button Logic
    answer = answer.replaceAll('%', '/100');

    Parser p = Parser();
    Expression exp = p.parse(answer);
    ContextModel cm = ContextModel();

    double eval = exp.evaluate(EvaluationType.REAL, cm);
    outputText = eval.toString();
    inputText = outputText;
    if (inputText.endsWith(".0")) {
      inputText = inputText.replaceAll(".0", "");
    }
    if (inputText.isNotEmpty) {
      setState(() {
        textColor = Colors.green;
      });
    }
    liveCalc = "";
    addHistory(answer, inputText);
  }

  //Function to show live calculation below the main Text Widget
  void showLiveCalc() {
    String answer = inputText;
    if (answer.isNotEmpty) {
      try {
        answer = answer.replaceAll('×', '*');
        answer = answer.replaceAll('%', '/100');

        Parser p = Parser();
        Expression exp = p.parse(answer);
        ContextModel cm = ContextModel();

        double eval = exp.evaluate(EvaluationType.REAL, cm);
        setState(() {
          liveCalc = eval.toString();
          if (liveCalc.endsWith(".0")) {
            liveCalc = liveCalc.replaceAll(".0", "");
          }
        });
      } catch (e) {
        setState(() {
          liveCalc = "";
        });
      }
    } else {
      setState(() {
        liveCalc = "";
      });
    }
  }

  void deleteColorChange() {
    setState(() {
      if (inputText.isNotEmpty) {
        deleteColor = Colors.green;
      } else {
        deleteColor = Colors.grey;
      }
    });
  }
}
