
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:numberpicker/numberpicker.dart';

import 'Widgets/SvpScaffold.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InventoryState createState() => _InventoryState ();
}

class _InventoryState extends State<InventoryPage> {

  int _bestandKaffee = 1;
  int _bestandKondensmilch = 1;

  TextEditingController dateCtl = TextEditingController();
  TextEditingController cucumberCtl = TextEditingController();

  static const PickerData = '''
[
    {
        "a": [
            {
                "a1": [
                    1,
                    2,
                    3,
                    4
                ]
            },
            {
                "a2": [
                    5,
                    6,
                    7,
                    8
                ]
            },
            {
                "a3": [
                    9,
                    10,
                    11,
                    12
                ]
            }
        ]
    },
    {
        "b": [
            {
                "b1": [
                    11,
                    22,
                    33,
                    44
                ]
            },
            {
                "b2": [
                    55,
                    66,
                    77,
                    88
                ]
            },
            {
                "b3": [
                    99,
                    1010,
                    1111,
                    1212
                ]
            }
        ]
    },
    {
        "c": [
            {
                "c1": [
                    "a",
                    "b",
                    "c"
                ]
            },
            {
                "c2": [
                    "aa",
                    "bb",
                    "cc"
                ]
            },
            {
                "c3": [
                    "aaa",
                    "bbb",
                    "ccc"
                ]
            }
        ]
    }
]
    ''';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _lowerValue;
  int _upperValue;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SvpScaffold(
      body: Container(
        width: 400.0,
        child: new Center(
          child: Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new NumberPicker.integer(
                      initialValue: _bestandKaffee,
                      minValue: 0,
                      maxValue: 10,
                      onChanged: (newValue) =>
                          setState(() => _bestandKaffee = newValue)
                  ),
                  new Text("Kaffee: $_bestandKaffee"),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new NumberPicker.integer(
                      initialValue: _bestandKondensmilch,
                      minValue: 0,
                      maxValue: 10,
                      onChanged: (newValue) =>
                          setState(() => _bestandKondensmilch = newValue)
                  ),
                  new Text("Kondensmilch: $_bestandKondensmilch"),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: new TextFormField(
                      controller: dateCtl,
                      decoration: InputDecoration(
                        labelText: "Würfelzucker",
                        hintText: "Anzahl Packungen eingeben",),
                      onTap: () async{
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = await showDatePicker(
                            context: context,
                            initialDate:DateTime.now(),
                            firstDate:DateTime(1900),
                            lastDate: DateTime(2100));

                        dateCtl.text = date.toIso8601String();},),
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: FlutterSlider(
                      step: 1,
                      max: 5,
                      min: 0,
                      centeredOrigin: true,
                      values: [ 0, 1, 2, 3, 4, 5 ],
                      handlerAnimation: FlutterSliderHandlerAnimation(
                          curve: Curves.elasticOut,
                          reverseCurve: Curves.bounceIn,
                          duration: Duration(milliseconds: 500),
                          scale: 1
                      ),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        _lowerValue = lowerValue;
                        _upperValue = upperValue;

                        if(handlerIndex == 0)
                          print(" Left handler ");
                        setState(() => _bestandKaffee = handlerIndex);

                        setState(() {_bestandKaffee =  handlerIndex;});
                      },
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        _lowerValue = lowerValue;
                        _upperValue = upperValue;

                        if(handlerIndex == 0)
                          print(" Left handler ");
                        setState(() => _bestandKaffee = handlerIndex);

                        setState(() {_bestandKaffee =  handlerIndex;});
                      },                      hatchMark: FlutterSliderHatchMark(
                        distanceFromTrackBar: 10,
                        density: 0.5, // means 50 lines, from 0 to 100 percent
                        labels: [
                          FlutterSliderHatchMarkLabel(percent: 0, label: Text('leer')),
                          FlutterSliderHatchMarkLabel(percent: 20, label: Text('1')),
                          FlutterSliderHatchMarkLabel(percent: 40, label: Text('2')),
                          FlutterSliderHatchMarkLabel(percent: 60, label: Text('3')),
                          FlutterSliderHatchMarkLabel(percent: 80, label: Text('4')),
                          FlutterSliderHatchMarkLabel(percent: 100, label: Text('voll')),
                        ],
                      ),
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black12,
                          border: Border.all(width: 3, color: Colors.blue),
                        ),
                        activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blue.withOpacity(0.5)
                        ),

                      ),
                    ),
                  ),
                  Text("Kaffee: $_bestandKaffee"),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: new TextFormField(
                      controller: cucumberCtl,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Essiggurken",
                        hintText: "Anzahl Gläser eingeben",),
                      onTap: () async{
                        int cucumbers = 1;
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        NumberPickerDialog myDialo = NumberPickerDialog.integer(
                          minValue: 1,
                          maxValue: 10,
                          title: new Text("Anzahl Gläser auswählen"),
                          initialIntegerValue: cucumbers,
                        );

                        cucumberCtl.text = cucumbers.toString();
                      },
                    ),
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: new TextFormField(
                      controller: cucumberCtl,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Essiggurken",
                        hintText: "Anzahl Gläser eingeben",),
                      onTap: () async{
                        int cucumbers = 1;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        Picker picker = Picker(
                            adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(PickerData)),
                            changeToFirst: true,
                            textAlign: TextAlign.left,
                            columnPadding: const EdgeInsets.all(8.0),
                            onConfirm: (Picker picker, List value) {
                              print(value.toString());
                              print(picker.getSelectedValues());
                            }
                        );
                        picker.showModal(this.context); //show(_scaffoldKey.currentState );

                        cucumberCtl.text = cucumbers.toString();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }
}