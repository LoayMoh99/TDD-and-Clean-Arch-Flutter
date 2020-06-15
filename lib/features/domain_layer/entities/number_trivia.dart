import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NumberTrivia extends Equatable {
  //equatble helps in detecting that 2 objects are equal by there values only..
  final String text;
  final int number;

  NumberTrivia({
    @required this.text,
    @required this.number,
  }) : super([text, number]);
}
