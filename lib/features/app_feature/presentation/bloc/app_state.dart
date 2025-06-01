import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/const/form_status.dart';

class AppState extends Equatable {
  const AppState({
    this.status = FormStatus.pure,
    this.statusChangeMode = FormStatus.pure,
    this.isReviewMode = true,
    this.error = '',
    this.productionUrl = '',
    this.themeMode = ThemeMode.system,
  });

  final FormStatus status;
  final FormStatus statusChangeMode;
  final String error;
  final String productionUrl;
  final bool isReviewMode;
  final ThemeMode themeMode;

  AppState copyWith({
    FormStatus? status,
    FormStatus? statusChangeMode,
    String? error,
    String? productionUrl,
    bool? isReviewMode,
    ThemeMode? themeMode,
  }) {
    return AppState(
      status: status ?? this.status,
      statusChangeMode: statusChangeMode ?? this.statusChangeMode,
      error: error ?? this.error,
      productionUrl: productionUrl ?? this.productionUrl,
      isReviewMode: isReviewMode ?? this.isReviewMode,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [
    status,
    statusChangeMode,
    themeMode,
    isReviewMode,
    productionUrl,
    error
  ];
}
