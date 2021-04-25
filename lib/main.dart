import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_color_picker/color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'constants_string.dart' as Constants;

void main() => runApp(MyApp()); // Because only one line with no return is the same then that

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter', // Useless !!! Ou du - non visible nul part.
      //home: RandomWords(),
      home: RandomWords(),
    );
  }
}



class RandomWords extends StatefulWidget {

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  // SharedPreferences attributes.
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Other attributes.
  final _suggestions = <WordPair>[];
  Color color = Colors.blue;

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      color = Color(prefs.getInt(Constants.colorSharedPrefsKey) ?? Colors.blue.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.palette), onPressed: _pushPalette),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushPalette() {
    final result = Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => MyColorPicker(color: this.color)
      ),
    ).then((value) => {
      //print("Value: " + value.toString()),
      setState((){
        this.color = value ?? this.color;
      }),
    });
  }

  Widget _buildSuggestions(){
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        //itemBuilder is a callback, call once per suggested word pairing.
        //and places each one into a ListTile row.
        itemBuilder: (BuildContext _context, int i){
          //Add a one-pixel-high divider widget before each row in ListView.
          if(i.isOdd){
            return Divider();
          }

          final int index = i ~/ 2;
          if(index >= _suggestions.length){
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index], index);
        }
    );
  }

  Widget _buildRow(WordPair pair, int i){
    return ListTile(
      title: NumberedWord(i, pair.asCamelCase, color),
    );
  }
}

class NumberedWord extends StatelessWidget{
  final int i;
  final String pair;
  final Color color;

  const NumberedWord(this.i, this.pair, this.color);

  @override
  Widget build(BuildContext context) {
    final _textGreen = TextStyle(color: color, fontSize: 18);
    final _biggerFont = const TextStyle(fontSize: 18);

    return Row(
      children: [
        Text(
          i.toString(),
          style: _textGreen,
        ),
        Padding(padding: const EdgeInsets.all(2)),
        Text(
          pair,
          style: _biggerFont,
        ),
      ],
    );
  }
}
