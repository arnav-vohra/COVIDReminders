import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:hello_world/store/store.dart';
import 'package:hello_world/actions/actions.dart';

class ContactPersonBuilder extends StatefulWidget {
  ContactPersonBuilder(
      {Key key, this.contactPersonName, this.contactPersonPhoneNumber})
      : super(key: key);

  final String contactPersonName;
  final String contactPersonPhoneNumber;

  @override
  _ContactPersonBuilderState createState() => _ContactPersonBuilderState();
}

class _ContactPersonBuilderState extends State<ContactPersonBuilder> {
  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;

  @override
  Widget build(BuildContext context) {
    //_prepareState();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Manage Contact Person'),
            color: Colors.blue,
            onPressed: () async {
              Contact contact = await _contactPicker.selectContact();
              setState(() {
                _contact = contact;
              });
              getStore().dispatch(SetContactAction(contact: contact));
            },
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  _prepareState() {
    // TODO: use this when displaying current contact selected by user
    //Contact currentContact = getStore().state.contactState.contact;
  }
}
