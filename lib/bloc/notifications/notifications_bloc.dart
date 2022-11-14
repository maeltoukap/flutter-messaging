import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/services/notification_service.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  bool? _subscribed;
  bool? get subscribed => _subscribed;

  Future configureFcmSubscription(bool isSubscribed) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('subscribed', isSubscribed);
    _subscribed = isSubscribed;

    NotificationService().handleFcmSubscribtion();
    // notifyListeners();
  }

  Future checkSubscription() async {
    await NotificationService()
        .handleFcmSubscribtion()
        .then((bool subscription) {
      _subscribed = subscription;
      // notifyListeners();
    });
  }

  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
