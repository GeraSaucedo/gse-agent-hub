import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    // Only the event type: freezed's toString includes every field, which
    // would log passwords and codes (e.g. PasswordChanged(password: ...)).
    AppLogger.i(
      'Bloc: ${bloc.runtimeType}, Event: ${event.runtimeType}',
      logName: 'BlocObserver',
    );
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.i('Bloc created: ${bloc.runtimeType}', logName: 'BlocObserver');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.i('Bloc closed: ${bloc.runtimeType}', logName: 'BlocObserver');
  }
}
