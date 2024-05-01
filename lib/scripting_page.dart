import 'package:flutter/material.dart';
import 'package:scripter/func_class.dart';
import 'package:url_launcher/url_launcher.dart';

class ScriptingPage extends StatefulWidget {
  const ScriptingPage({super.key});

  @override
  State<ScriptingPage> createState() => _ScriptingPageState();
}

class _ScriptingPageState extends State<ScriptingPage> {
  List<FunctionTemplate> predefinedFunctions = [
    FunctionTemplate(
      name: 'MathExpression',
      parameters: [
        {'name': 'expression', 'value': ''},
        {'name': 'round', 'value': ''}
      ],
      result: '',
      function: (List<dynamic> params) {
        // Extract parameters
        String expression = params[0];
        int round = params[1] != ''
            ? int.parse(params[1])
            : 0; // Convert round to integer

        // Remove white spaces
        expression = expression.replaceAll(' ', '');

        // Find operator index
        int operatorIndex = expression.indexOf(new RegExp(r'[+\-*/]'));
        if (operatorIndex == -1) {
          // No operator found, invalid expression
          return 'Invalid expression';
        }

        // Extract operands
        double operand1 = double.parse(expression.substring(0, operatorIndex));
        double operand2 = double.parse(expression.substring(operatorIndex + 1));

        // Perform calculation based on operator
        double result;
        switch (expression[operatorIndex]) {
          case '+':
            result = operand1 + operand2;
            break;
          case '-':
            result = operand1 - operand2;
            break;
          case '*':
            result = operand1 * operand2;
            break;
          case '/':
            if (operand2 == 0) {
              return 'Division by zero';
            }
            result = operand1 / operand2;
            break;
          default:
            // Invalid operator
            return 'Invalid operator';
        }

        // Round result if required
        if (round > 0) {
          result = double.parse(result.toStringAsFixed(round));
        }
        print(result);
        // Return the result
        return result.toString();
      },
    ),

    FunctionTemplate(
      name: 'OpenUrl',
      parameters: [
        {'name': 'url', 'value': ''}
      ],
      result: '',
      function: (List<dynamic> params) async {
        Uri url = Uri.parse(params[0]);

        try {
          await launchUrl(url);
          return 'URL opened successfully';
        } catch (e) {
          print('Error opening URL: $e');
          return 'Failed to open URL';
        }
      },
    ),

    FunctionTemplate(
      name: 'Pause',
      parameters: [
        {'name': 'time', 'value': ''}
      ],
      result: '',
      function: (List<dynamic> params) async {
        int? duration = int.tryParse(params[0] ?? '');
        if (duration != null && duration > 0) {
          await Future.delayed(Duration(milliseconds: duration));
          return 'Paused for $duration milliseconds';
        } else {
          return 'Invalid duration';
        }
      },
    ),

    // Add more predefined functions here
  ];

  List<FunctionTemplate> userScript = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scripting App'),
      ),
      body: Column(
        children: [
          // Show predefined functions as buttons
          Row(
            children: [
              for (var func in predefinedFunctions)
                Row(
                  children: [
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Create new controllers and parameters for each function template
                          List<TextEditingController> controllers = [];
                          List<Map<String, dynamic>> parameters = [];

                          for (var param in func.parameters!) {
                            parameters.add({
                              'name': param['name'],
                              'value': param['value']
                            });
                          }

                          for (int i = 0; i < func.parameters!.length; i++) {
                            controllers.add(TextEditingController(
                                text: func.parameters![i]['value']));
                          }

                          userScript.add(FunctionTemplate(
                            name: func.name,
                            parameters:
                                parameters, // Use the new parameters list
                            result: func.result,
                            controllers: controllers,
                            function: func.function,
                          ));
                        });
                      },
                      child: Text(func.name!),
                    ),
                  ],
                ),
            ],
          ),

          // Show user selected functions with input fields
          for (var func in userScript)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${func.name!}:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (int i = 0; i < func.parameters!.length; i++)
                  Container(
                    // Wrap SizedBox with Container
                    height: 20,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '  ${func.parameters![i]['name']}: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          // Wrap TextField with Expanded
                          child: TextField(
                            controller: func.controllers![i],
                            onChanged: (value) {
                              func.parameters![i]['value'] = value;
                            },
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none, // Remove all borders
                              enabledBorder: InputBorder
                                  .none, // Remove border when not focused
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          // Run button
          ElevatedButton(
            onPressed: _runScript,
            child: Text('Run'),
          ),
        ],
      ),
    );
  }

  Future<void> _runScript() async {
    print('Running script...'); // Add this line for debugging

    // Execute the user script
    for (var func in userScript) {
      print(func.parameters);
      // Prepare parameters for the function
      List<dynamic> params = [];
      for (var param in func.parameters!) {
        // print(param);
        params.add(param['value']);
      }
      // Execute the function and update the result

      //print(func.function);
      func.result = await func.function!(params);
      setState(() {
        print(func.result); // Call the function directly
      });
    }
  }
}
