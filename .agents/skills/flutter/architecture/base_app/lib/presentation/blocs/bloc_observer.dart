import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.i(
      'Bloc: ${bloc.runtimeType}, Event: $event - ${DateTime.now()}',
      logName: 'BlocObserver',
    );
  }

  /*  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLogger.i(
        '${transition.currentState} -> ${transition.nextState}');
  } */

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.i(
      '========= Bloc: ${bloc.runtimeType} CERRADO ==========',
      logName: 'BlocObserver',
    );
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.i(
      '========= Bloc: ${bloc.runtimeType}, CREADO =====',
      logName: 'BlocObserver',
    );
  }
}
