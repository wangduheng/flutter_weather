import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
class ThemeState extends Equatable {
  final ThemeData theme;
  final MaterialColor color;

  ThemeState({this.theme, this.color})
      : super([theme, color]);
}