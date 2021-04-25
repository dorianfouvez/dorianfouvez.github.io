import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'constants_string.dart' as Constants;

class MyColorPicker extends StatefulWidget {
  final Color color;

  MyColorPicker({this.color = Colors.blue});

  @override
  State<StatefulWidget> createState() => _ColorPicker(this.color);
}

class _ColorPicker extends State<MyColorPicker> {
  // SharedPreferences attributes.
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // ColorPicker pub.dev attributes.
  Color color = Colors.blue;

  _ColorPicker(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _pushSave),
        ],
      ),
      body: Column(children: [
        _createText(color),
        Row(
          children: [
            _pubDev(),
          ],
        ),
      ]),
    );
  }

  void _pushSave() async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt(Constants.colorSharedPrefsKey, (color.value));
    Navigator.pop(context, color);
  }

  Text _createText(Color color) {
    var _biggerFont = TextStyle(color: color, fontSize: 40);
    return Text(
      "Pick a color !",
      style: _biggerFont,
    );
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    _prefs.then((value) => {
      setState(() => this.color = color),
    });
  }

  AlertDialog _pubDev(){
    return AlertDialog(
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: changeColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
    );
  }
}
