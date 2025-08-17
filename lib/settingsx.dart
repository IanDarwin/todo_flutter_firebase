import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

/// Activity for Settings.
///
class SettingsPage extends StatefulWidget {

  @override
  SettingsState createState() => new SettingsState();

}

class SettingsState extends State<SettingsPage> {

  final OpsUnit defaultOpsUnit = OpsUnit.NA_US;
  final Map<int,String> opsUnitMap = Map();

  SettingsState();

  @override
  void initState() {
    _defaultAddToCal();
    OpsUnit.values.forEach((ou) { opsUnitMap.putIfAbsent(ou.index, ou.toString);});
    super.initState();
  }

  /// "Add to Calendar" - if not set in prefs, default to true;
  /// "async" but not called from async code
  _defaultAddToCal() async {
	  if (prefs.getBool(Constants.KEY_SAVE_TO_CAL) == null) {
		  await prefs.setBool(Constants.KEY_SAVE_TO_CAL, true);
	  }
  }

  @override
  Widget build(BuildContext context) {

    return SettingsScreen(title: "iCheckIn Settings",
        children: <Widget>[
          SettingsGroup(title: "Authentication",
              children: [
                
              ]),
          SettingsGroup(
            title: "Personalization",
            children: [
              DropDownSettingsTile<int>(
                title: 'Default Course Length',
                settingKey: Constants.KEY_COURSE_LENGTH,
                  selected: defaultCourseLength,
                  values: {
                  1: "1",
                  2: "2",
                  3: "3",
                  4: "4",
                  5: "5",
                }
              ),
              
            ],
          ),
          SettingsGroup(
            title: "Personalization",
            children: [
              SwitchSettingsTile(
                title: "Dark mode",
                  leading: Icon(Icons.dark_mode),
                  settingKey: Constants.KEY_DARK_MODE,
                  onChange: (val) {
                    alert(context, "Change will take effect on app restart",
                        title:"Dark Mode ${val?'on':'off'}");
                  })
              ],
        )
      ]
    );
  }

  @override
  void dispose() {
	// Do we need anything here?
	super.dispose();
  }
}

