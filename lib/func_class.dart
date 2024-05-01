import 'package:flutter/material.dart';

class FunctionTemplate {
  String? name;
  List<Map<String, dynamic>>? parameters;
  String? result;
  List<TextEditingController>? controllers;
  Function? function;

  FunctionTemplate({
    this.name,
    this.parameters,
    this.result,
    this.controllers,
    Function? function,
  }) : function = function;
}
