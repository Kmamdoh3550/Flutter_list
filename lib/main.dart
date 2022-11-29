import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listhttp/services/httpservice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Coins(),
    );
  }
}

class Coins extends StatefulWidget {
  const Coins({Key? key}) : super(key: key);

  @override
  State<Coins> createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  String coin = '';
  bool _searchBoolean = false;
  Widget _searchTextField() {
    //add
    return TextField(
      onChanged: ((value) => setState(() {
            coin = value;
          })),
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction:
          TextInputAction.search, //Specify the action button on the keyboard
      decoration: const InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle(
          //Style of hintText
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HttpService service = HttpService();

    return Scaffold(
      appBar: AppBar(
        actions: !_searchBoolean
            ? [
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = true;
                      });
                    })
              ]
            : [
                IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        coin = '';
                        _searchBoolean = false;
                      });
                    })
              ],
        title: !_searchBoolean
            ? const Center(child: Text('Coins List'))
            : _searchTextField(),
      ),
      body: FutureBuilder(
        future: coin == '' ? service.getCoins() : service.getCoinsFilter(coin),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data[index].id.toString(),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey),
                        ),
                        Text(
                          snapshot.data[index].name.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Coins Size',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[700]),
                            ),
                            Text(
                              snapshot.data[index].minsize.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green[400]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
