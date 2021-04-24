import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hello_world/actions/actions.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/index.dart';
import 'package:hello_world/store/store.dart';
import 'package:hello_world/utils/notificationHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import 'ReminderCustomItem.dart';
import 'ReminderItem.dart';

const String playMusic = 'Do gargling';
const String lookAfterPlants = 'Measure Stats';
const String walk = 'Walk/exercise';
const String drinkingWater = 'Drink warm water';
const String custom = 'Take Steam';
const String custom2 = 'Take Steam 2';

const remindersIcons = {
  playMusic: Icons.emoji_food_beverage_sharp,
  lookAfterPlants: Icons.thermostat_outlined,
  walk: Icons.directions_walk,
  drinkingWater: Icons.local_drink,
  custom: Icons.stream,
  custom2: Icons.stream,
};

class ReminderAlertBuilder extends StatefulWidget {
  ReminderAlertBuilder({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReminderAlertBuilderState createState() => _ReminderAlertBuilderState();
}

class _ReminderAlertBuilderState extends State<ReminderAlertBuilder> {
  bool playMusicReminder = false;
  bool lookAfterPlantsReminder = false;
  bool walkFor5minReminder = false;
  bool drinkSomeWaterReminder = false;
  bool customReminder = false;
  double margin = Platform.isIOS ? 10 : 5;

  TimeOfDay customNotificationTime;
  TimeOfDay customNotificationTime2;

  @override
  Widget build(BuildContext context) {
    _prepareState();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Manage reminders'),
            color: Colors.blue,
            onPressed: _showMaterialDialog,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.all(0.0),
              backgroundColor: Colors.white,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height - 80,
                    padding: EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                            padding: new EdgeInsets.only(bottom: margin),
                            child: Text(
                              'Thrice a day',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            )),
                        ReminderItem(
                          onChanged: (value) {
                            setState(() {
                              playMusicReminder = value;
                            });
                            _configurePlayMusic(value);
                          },
                          checkBoxValue: playMusicReminder,
                          iconName: playMusic,
                        ),
                        Padding(
                            padding: new EdgeInsets.only(top: margin),
                            child: Text(
                              'Thrice a day',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            )),
                        ReminderItem(
                          onChanged: (value) {
                            setState(() {
                              lookAfterPlantsReminder = value;
                            });
                            _configureLookAfterPlants(value);
                          },
                          checkBoxValue: lookAfterPlantsReminder,
                          iconName: lookAfterPlants,
                        ),
                        Padding(
                            padding: new EdgeInsets.only(top: margin),
                            child: Text(
                              'Every 2 hours',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            )),
                        ReminderItem(
                          onChanged: (value) {
                            setState(() {
                              walkFor5minReminder = value;
                            });
                            _configure5minWalk(value);
                          },
                          checkBoxValue: walkFor5minReminder,
                          iconName: walk,
                        ),
                        Padding(
                            padding: new EdgeInsets.only(top: margin),
                            child: Text(
                              'Every 2 hours',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            )),
                        ReminderItem(
                          onChanged: (value) {
                            setState(() {
                              drinkSomeWaterReminder = value;
                            });
                            _configureDrinkSomeWater(value);
                          },
                          checkBoxValue: drinkSomeWaterReminder,
                          iconName: drinkingWater,
                        ),
                        Padding(
                            padding: new EdgeInsets.only(top: margin),
                            child: Text(
                              'Twice a day',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            )),
                        ReminderCustomItem(
                            checkBoxValue: customReminder,
                            iconName: custom,
                            onChanged: (value) {
                              setState(() {
                                customReminder = value;
                              });
                              _configureCustomReminder(value);
                              _configureCustomReminder2(value);
                            },
                            showTimeDialog: () {
                              _showTimeDialog(setState);
                            },
                            showTimeDialog2: () {
                              _showTimeDialog2(setState);
                            }),
                        Padding(
                          padding: new EdgeInsets.only(
                              top: margin * 2, bottom: margin),
                          child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "SAVE",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                );
              }));
        });
  }

  _showTimeDialog(StateSetter setState) async {
    var previousCustomNotificationTime = customNotificationTime;
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    setState(() {
      customNotificationTime = selectedTime;
      customReminder = true;
    });

    if (previousCustomNotificationTime != null) {
      getStore().dispatch(RemoveReminderAction(custom));
      turnOffNotificationById(flutterLocalNotificationsPlugin, 50);
    }

    _configureCustomReminder(true);
  }

  _showTimeDialog2(StateSetter setState) async {
    var previousCustomNotificationTime2 = customNotificationTime2;
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    setState(() {
      customNotificationTime2 = selectedTime;
      customReminder = true;
    });

    if (previousCustomNotificationTime2 != null) {
      getStore().dispatch(RemoveReminderAction(custom2));
      turnOffNotificationById(flutterLocalNotificationsPlugin, 51);
    }

    _configureCustomReminder2(true);
  }

  _prepareState() {
    List<Reminder> list = getStore().state.remindersState.reminders;

    list.forEach((item) {
      switch (item.name) {
        case playMusic:
          playMusicReminder = true;
          break;
        case lookAfterPlants:
          lookAfterPlantsReminder = true;
          break;
        case walk:
          walkFor5minReminder = true;
          break;
        case drinkingWater:
          drinkSomeWaterReminder = true;
          break;
        case custom:
          customReminder = true;
          break;
        default:
          return;
      }
    });
  }

  void _configurePlayMusic(bool value) {
    if (value) {
      getStore().dispatch(SetReminderAction(
          time: new DateTime.now().toIso8601String(),
          name: playMusic,
          repeat: RepeatInterval.Daily));

      for (int i = 0; i < 3; i++) {
        var now = new DateTime.now();
        var notificationTime =
            new DateTime(now.year, now.month, now.day, 9 + 6 * i, 0);
        scheduleNotification(flutterLocalNotificationsPlugin, i.toString(),
            playMusic, notificationTime);
      }
    } else {
      for (int i = 0; i < 3; i++) {
        turnOffNotificationById(flutterLocalNotificationsPlugin, i);
      }
      getStore().dispatch(RemoveReminderAction(playMusic));
    }
  }

  void _configureLookAfterPlants(bool value) {
    if (value) {
      getStore().dispatch(SetReminderAction(
          time: new DateTime.now().toIso8601String(),
          name: lookAfterPlants,
          repeat: RepeatInterval.Daily));
      for (int i = 10; i < 13; i++) {
        var now = new DateTime.now();
        var notificationTime =
            new DateTime(now.year, now.month, now.day, 9 + 6 * (i - 10), 0);
        scheduleNotification(flutterLocalNotificationsPlugin, i.toString(),
            lookAfterPlants, notificationTime);
      }
    } else {
      getStore().dispatch(RemoveReminderAction(lookAfterPlants));
      for (int i = 10; i < 13; i++) {
        turnOffNotificationById(flutterLocalNotificationsPlugin, i);
      }
    }
  }

  void _configure5minWalk(bool value) {
    if (value) {
      getStore().dispatch(SetReminderAction(
          time: new DateTime.now().toIso8601String(),
          name: walk,
          repeat: RepeatInterval.Hourly));
      for (int i = 20; i < 27; i++) {
        var now = new DateTime.now();
        var notificationTime =
            new DateTime(now.year, now.month, now.day, 9 + 2 * (i - 20), 0);
        scheduleNotification(flutterLocalNotificationsPlugin, i.toString(),
            walk, notificationTime);
      }
    } else {
      getStore().dispatch(RemoveReminderAction(walk));
      for (int i = 20; i < 27; i++) {
        turnOffNotificationById(flutterLocalNotificationsPlugin, i);
      }
    }
  }

  void _configureDrinkSomeWater(bool value) {
    if (value) {
      getStore().dispatch(SetReminderAction(
          time: new DateTime.now().toIso8601String(),
          name: drinkingWater,
          repeat: RepeatInterval.EveryMinute));
      for (int i = 30; i < 37; i++) {
        var now = new DateTime.now();
        var notificationTime =
            new DateTime(now.year, now.month, now.day, 9 + 2 * (i - 30), 0);
        scheduleNotification(flutterLocalNotificationsPlugin, i.toString(),
            drinkingWater, notificationTime);
      }
    } else {
      getStore().dispatch(RemoveReminderAction(drinkingWater));
      for (int i = 30; i < 37; i++) {
        turnOffNotificationById(flutterLocalNotificationsPlugin, i);
      }
    }
  }

  void _configureCustomReminder(bool value) {
    if (customNotificationTime != null) {
      if (value) {
        var now = new DateTime.now();
        var notificationTime = new DateTime(now.year, now.month, now.day,
            customNotificationTime.hour, customNotificationTime.minute);

        getStore().dispatch(SetReminderAction(
            time: notificationTime.toIso8601String(),
            name: custom,
            repeat: RepeatInterval.Daily));
        scheduleNotification(
            flutterLocalNotificationsPlugin, '50', custom, notificationTime);
      } else {
        getStore().dispatch(RemoveReminderAction(custom));
        turnOffNotificationById(flutterLocalNotificationsPlugin, 50);
      }
    }
  }

  void _configureCustomReminder2(bool value) {
    if (customNotificationTime2 != null) {
      if (value) {
        var now = new DateTime.now();
        var notificationTime = new DateTime(now.year, now.month, now.day,
            customNotificationTime2.hour, customNotificationTime2.minute);

        getStore().dispatch(SetReminderAction(
            time: notificationTime.toIso8601String(),
            name: custom2,
            repeat: RepeatInterval.Daily));

        scheduleNotification(
            flutterLocalNotificationsPlugin, '51', custom2, notificationTime);
      } else {
        getStore().dispatch(RemoveReminderAction(custom2));
        turnOffNotificationById(flutterLocalNotificationsPlugin, 51);
      }
    }
  }
}
