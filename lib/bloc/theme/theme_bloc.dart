import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }


  final String key = "theme";
  SharedPreferences? _pref;
  bool? _darkTheme;

  bool? get darkTheme => _darkTheme;

  // ThemeBloc() {
  //   _darkTheme = false;
  //   _loadFromPrefs();
  // }

  toggleTheme(){
    _darkTheme = !_darkTheme!;
    _saveToPrefs();
    // notifyListeners();
  }

  _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  loadFromPrefs() async {
      await _initPrefs();
      _darkTheme = _pref!.getBool(key) ?? false;
      // notifyListeners();
  }
  
  _saveToPrefs() async {
    await _initPrefs();
    _pref!.setBool(key, _darkTheme!);
  }
}
