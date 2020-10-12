import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final key = new GlobalKey<ScaffoldState>();
  double _numberFrom;
  String _result;
  final Map<String, int> _measuresMap = {
  'meters' : 0,
  'kilometers' : 1,
  'grams' : 2,
  'kilograms' : 3,
  'feet' : 4,
  'miles' : 5,
  'pounds (lbs)' : 6,
  'ounces' : 7,
  };
  final dynamic _formulas = {
    '0':[1,0.001,0,0,3.28084,0.000621371,0,0],
    '1':[1000,1,0,0,3280.84,0.621371,0,0],
    '2':[0,0,1,0.0001,0,0,0.00220462,0.035274],
    '3':[0,0,1000,1,0,0,2.20462,35.274],
    '4':[0.3048,0.0003048,0,0,1,0.000189394,0,0],
    '5':[1609.34, 1.60934,0,0,5280,1,0,0],
    '6':[0,0,453.592,0.453592,0,0,1,16],
    '7':[0,0,28.3495,0.0283495,3.28084,0,0.0625, 1],
  };

  final List<String> _measure = ['meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];
  String _startMeasure, _toMeasure;
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle inputStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.blueAccent,
    );
    final TextStyle labelStyle = TextStyle(
      fontSize: 24.0,
      color: Colors.grey[400],
    );
    return MaterialApp(
      title: "Unit Converter",
      home: Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Unit Converter"),
          centerTitle: true,
          backgroundColor: Colors.blue[500],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0,),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.0,),
                Text("Value", style: labelStyle,),
                SizedBox(height: 20.0,),
                TextField(
                  style: inputStyle,
                  decoration: InputDecoration(hintText: "Enter a value",),
                  onChanged: (val){
                    var value = double.tryParse(val);
                    if(value != null){
                      setState(() {
                        _numberFrom = value;
                      });
                    }
                    else{
                      setState(() {
                        _numberFrom = 0;
                      });
                    }
                  },
                ),
                SizedBox(height: 20.0,),
                Text("From", style: labelStyle,),
                DropdownButton(
                  isExpanded: true,
                  value: _startMeasure,
                    items: _measure.map((String val){
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val, style: inputStyle,),
                      );
                    }).toList(),
                    onChanged: (val){
                      setState(() {
                        _startMeasure = val;
                      });
                    },
                ),
                SizedBox(height: 20.0,),
                Text("To", style: labelStyle,),
                DropdownButton(
                  isExpanded: true,
                  value: _toMeasure,
                  items: _measure.map((String val){
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val, style: inputStyle),
                    );
                  }).toList(),
                  onChanged: (val){
                    setState(() {
                      _toMeasure = val;
                    });
                  },
                ),
                SizedBox(height: 30.0,),
                RaisedButton(
                  child: Text("Convert", style: inputStyle,),
                  onPressed: (){
                    if(_numberFrom == 0){
                      key.currentState.showSnackBar(SnackBar(content: Text("Enter some value"),));
                    }
                    else if(_startMeasure == null || _toMeasure == null){
                      key.currentState.showSnackBar(SnackBar(content: Text("Select an unit")));
                    }
                    else{
                      convert(_numberFrom, _startMeasure, _toMeasure);
                    }
                  },
                ),
                SizedBox(height: 30.0,),
                Text(_result == null ? "" : _result.toString(), style: labelStyle,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void convert(double value, String from, String to){
    int nfrom = _measuresMap[from];
    int nto = _measuresMap[to];
    var mul = _formulas[nfrom.toString()][nto];
    var res = mul * value;
    setState(() {
      if(res == 0){
        key.currentState.showSnackBar(SnackBar(content: Text("Conversion cannot be done")));
      }
      else{
        _result = res.toString();
      }
    });
  }
}