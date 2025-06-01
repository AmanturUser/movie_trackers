import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends AppEvent {
  final ThemeMode themeMode;

  const ChangeTheme(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class LoadAppMode extends AppEvent {}

class AppModeChanged extends AppEvent {
  final String mode;
  final String productionUrl;

  const AppModeChanged({
    required this.mode,
    required this.productionUrl,
  });

  @override
  List<Object> get props => [mode, productionUrl];
}

class UpdateAppMode extends AppEvent {
  final String mode;

  const UpdateAppMode(this.mode);

  @override
  List<Object> get props => [mode];
}