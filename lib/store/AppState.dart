import 'package:flutter/material.dart';
import 'package:hello_world/store/ContactState.dart';
import 'package:hello_world/store/RemindersState.dart';

@immutable
class AppState {
  final RemindersState remindersState;
  final ContactState contactState;

  AppState({@required this.remindersState, @required this.contactState});

  factory AppState.initial() {
    return AppState(
        remindersState: RemindersState.initial(),
        contactState: ContactState.initial());
  }

  dynamic toJson() {
    return {
      'remindersState': this.remindersState.toJson(),
      'contactState': this.contactState.toJson()
    };
  }

  static AppState fromJson(dynamic json) {
    return json != null
        ? AppState(
            remindersState: RemindersState.fromJson(json["remindersState"]),
            contactState:
                ContactState.fromJson(json["contactState"]["contact"]))
        : {};
  }

  AppState copyWith({RemindersState remindersState}) {
    return AppState(
        remindersState: remindersState ?? this.remindersState,
        contactState: contactState ?? this.contactState);
  }
}
