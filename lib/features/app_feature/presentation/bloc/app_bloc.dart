import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/const/form_status.dart';
import '../../../../core/services/firebase_service.dart';
import 'app_event.dart';
import 'app_state.dart';


class AppBloc extends Bloc<AppEvent, AppState> {
  final FirebaseService _firebaseService;
  StreamSubscription<String>? _modeSubscription;
  StreamSubscription<String>? _urlSubscription;

  String _currentMode = '';
  String _currentUrl = '';
  AppBloc(this._firebaseService) : super(AppState()) {
    on<LoadAppMode>(_onLoadAppMode);
    on<AppModeChanged>(_onAppModeChanged);
    on<UpdateAppMode>(_onUpdateAppMode);
    on<ChangeTheme>(_changeTheme);
  }

  _changeTheme(ChangeTheme event, Emitter emit) async {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  _onLoadAppMode(LoadAppMode event, Emitter emit) async {
    emit(state.copyWith(status: FormStatus.submissionInProgress));

    try {
      _currentMode = await _firebaseService.getMode();
      _currentUrl = await _firebaseService.getProductionUrl();

      emit(state.copyWith(status: FormStatus.submissionSuccess, isReviewMode: _currentMode == 'review' ? true : false, productionUrl: _currentUrl));

      _modeSubscription = _firebaseService.getModeStream().listen((mode) {
        _currentMode = mode;
        add(AppModeChanged(mode: _currentMode, productionUrl: _currentUrl));
      });

      _urlSubscription = _firebaseService.getProductionUrlStream().listen((url) {
        _currentUrl = url;
        add(AppModeChanged(mode: _currentMode, productionUrl: _currentUrl));
      });

    } catch (e) {
      emit(state.copyWith(status: FormStatus.submissionFailure, error: e.toString()));
    }
  }

  _onAppModeChanged(AppModeChanged event, Emitter emit) {
    emit(state.copyWith(statusChangeMode: FormStatus.submissionInProgress));
    emit(state.copyWith(statusChangeMode: FormStatus.submissionSuccess, isReviewMode: _currentMode == 'review' ? true : false, productionUrl: _currentUrl));
  }

  _onUpdateAppMode(UpdateAppMode event, Emitter emit) async {
    try {
      await _firebaseService.setMode(event.mode);
    } catch (e) {
      emit(state.copyWith(status: FormStatus.submissionFailure, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _modeSubscription?.cancel();
    _urlSubscription?.cancel();
    return super.close();
  }
}
