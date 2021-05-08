import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  List<String> coins = [
    'bitcoin',
    'tether',
    'ethereum',
    'doge'
  ];

  String dropdownValue = 'bitcoin';
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            DropdownButton(
              value: dropdownValue,
              onChanged: (String value) {
                setState(() {
                  dropdownValue = value;
                });
              },
              items: coins.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(growable: true),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Coin Amount',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: MaterialButton(
                onPressed: () async {
                  //why .text wtf
                  await addCoin(dropdownValue, _amountController.text);
                  
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
