import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hello_world/store/ContactState.dart';
import 'package:contact_picker/contact_picker.dart';

class SetReminderAction {
  final String time;
  final RepeatInterval repeat;
  final String name;

  SetReminderAction({this.time, this.repeat, this.name});
}

class RemoveReminderAction {
  final String name;

  RemoveReminderAction(this.name);
}

class ClearReminderAction {}

class SetContactAction {
  final Contact contact;

  SetContactAction({this.contact});
}
