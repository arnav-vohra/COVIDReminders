import 'package:hello_world/actions/actions.dart';
import 'package:hello_world/models/Reminder.dart';
import 'package:hello_world/store/AppState.dart';
import 'package:hello_world/store/RemindersState.dart';
import 'package:hello_world/store/ContactState.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
    remindersState: remindersReducer(state.remindersState, action),
    contactState: contactReducer(state.contactState, action));

final remindersReducer = combineReducers<RemindersState>([
  TypedReducer<RemindersState, SetReminderAction>(_setReminderAction),
  TypedReducer<RemindersState, ClearReminderAction>(_clearReminderAction),
  TypedReducer<RemindersState, RemoveReminderAction>(_removeReminderAction),
]);

final contactReducer = combineReducers<ContactState>([
  TypedReducer<ContactState, SetContactAction>(_setContactAction),
]);

RemindersState _setReminderAction(
    RemindersState state, SetReminderAction action) {
  var remindersList = state.reminders;
  if (remindersList != null) {
    remindersList.add(new Reminder(
        repeat: action.repeat, name: action.name, time: action.time));
  }
  return state.copyWith(reminders: remindersList);
}

RemindersState _clearReminderAction(
        RemindersState state, ClearReminderAction action) =>
    state.copyWith(reminders: []);

RemindersState _removeReminderAction(
    RemindersState state, RemoveReminderAction action) {
  var remindersList = state.reminders;
  remindersList.removeWhere((reminder) => reminder.name == action.name);
  return state.copyWith(reminders: remindersList);
}

ContactState _setContactAction(ContactState state, SetContactAction action) {
  return state.copyWith(contact: action.contact);
}
