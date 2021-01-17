import 'package:flutter/material.dart';
import 'package:flutter_tip_calculator/util/hexcolor.dart';

class BillSplitter extends StatefulWidget {
  BillSplitter({Key key}) : super(key: key);

  @override
  _BillSplitterState createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;

  Color _purple = HexColor('#6908D6');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      alignment: Alignment.center,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(20.5),
        children: <Widget>[
          Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color:
                      _purple.withOpacity(0.1), //color: Colors.purple.shade400,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Kişi Başına Düşen',
                      style: TextStyle(
                          color: _purple,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                        '${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)} ₺',
                        style: TextStyle(
                            color: _purple,
                            fontSize: 30,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.blueGrey.shade100, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: _purple),
                  decoration: InputDecoration(
                      prefixText: "Hesap Ücreti: ",
                      prefixIcon: Icon((Icons.attach_money))),
                  onChanged: (String value) {
                    try {
                      _billAmount = double.parse(value);
                    } catch (exception) {
                      _billAmount = 0.0;
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Kişi Sayısı',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: _getTapMinus,
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: _purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Center(
                              child: Text('-',
                                  style: TextStyle(
                                      color: _purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                            ),
                          ),
                        ),
                        Text(
                          '$_personCounter',
                          style: TextStyle(
                              color: _purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        InkWell(
                          onTap: _getTapPlus,
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: _purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Center(
                              child: Text('+',
                                  style: TextStyle(
                                      color: _purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Bahşiş',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 18.0)),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                          '${(calculateTotalTip(_billAmount, _personCounter, _tipPercentage)).toStringAsFixed(2)} ₺',
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0)),
                    )
                  ],
                ),
                Column(children: <Widget>[
                  Text('$_tipPercentage%',
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                  Slider(
                      min: 0.0,
                      max: 100.0,
                      activeColor: _purple,
                      divisions: 10,
                      inactiveColor: Colors.grey.shade300,
                      value: _tipPercentage.toDouble(),
                      onChanged: _changePerc)
                ])
              ],
            ),
          )
        ],
      ),
    ));
  }

  void _getTapMinus() {
    setState(() {
      if (_personCounter > 1) {
        _personCounter--;
      }
    });
  }

  void _getTapPlus() {
    setState(() {
      _personCounter++;
    });
  }

  void _changePerc(double value) {
    setState(() {
      _tipPercentage = value.round();
    });
  }

  calculateTotalPerPerson(double billAmount, int splitBy, int tipPerc) {
    var totalPerPerson =
        (calculateTotalTip(billAmount, splitBy, tipPerc) + billAmount) /
            splitBy;
    return totalPerPerson.toStringAsFixed(2);
  }

  calculateTotalTip(double billAmount, int splitBy, int tipPerc) {
    double totalTip = 0.0;
    if (billAmount < 0 || billAmount.toString().isEmpty || billAmount == null) {
      return;
    } else {
      totalTip = (billAmount * tipPerc) / 100;
    }
    return totalTip;
  }
}
