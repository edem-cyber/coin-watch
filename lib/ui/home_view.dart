import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:crypto_wallet/ui/add_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;
  double doge = 0.0;

  @override
  @override
  void initState() {
    getValues();
  }

  getValues() async {
    bitcoin = await getPrice('bitcoin');
    ethereum = await getPrice('ethereum');
    tether = await getPrice('tether');
    doge = await getPrice('doge');
    //remove setstate later
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount) {
      if (id == 'bitcoin') {
        return bitcoin * amount;
      } else if (id == 'ethereum') {
        return ethereum * amount;
      } else if (id == 'tether') {
        return tether * amount;
      } else if (id == 'doge') {
        return doge * amount;
      }
    }

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection('Coins')
                  .snapshots(),
              // ignore: missing_return
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }

                return ListView(
                  children: snapshot.data.docs.map((document) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.height / 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 5),
                            Text(
                              '${document.id}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '\$${getValue(document.id, document.data()['Amount']).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () async {
                                await removeCoin(document.id);
                              },
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddView()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
