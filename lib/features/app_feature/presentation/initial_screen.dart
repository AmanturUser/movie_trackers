import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tracers/core/auto_route/auto_route.dart';
import 'package:movie_tracers/features/movie_feature/presentation/movie_list.dart';
import 'package:movie_tracers/features/web_view_feature/presentation/web_view_screen.dart';

import '../../../core/const/form_status.dart';
import '../../../core/services/navigation_service.dart';
import 'bloc/app_bloc.dart';
import 'bloc/app_state.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen:
          (previous, current) => previous.status != current.status || previous.statusChangeMode != current.statusChangeMode,
      builder: (context, state) {
        if (state.status == FormStatus.submissionSuccess &&
            !(state.isReviewMode)) {
          return WebViewScreen();
        }
        if (state.status == FormStatus.submissionSuccess &&
            state.isReviewMode) {
          return MovieListScreen();
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
