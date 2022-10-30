import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
// import 'package:package_info/package_info.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

    String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;



  // void getPackageInfo () async{
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   _appVersion = packageInfo.version;
  //   _packageName = packageInfo.packageName;
  //   notifyListeners();
    
  // }
}
