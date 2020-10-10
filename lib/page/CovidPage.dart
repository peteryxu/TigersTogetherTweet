import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// help reduce anxiety
// some kind of WEAR A MASK Icon
// getting latest info for WHO, and help
// Orange county: https://www.orangecountync.gov/2332/Coronavirus-COVID-19
// UNC Carolina Together: https://carolinatogether.unc.edu/dashboard/

// ignore: must_be_immutable
class CovidPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CovidPage({Key key, this.scaffoldKey}) : super(key: key);

  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  int _index = 0;

  final String api = "https://coronavirus-19-api.herokuapp.com/countries";
  List data;

  @override
  void initState() {
    super.initState();
    this.getAllData();
  }

  Future<List> getAllData() async {
    var response = await http.get(api);
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson;
    });

    return data;
  }

  _launchURL() async {
    const url = 'https://www.orangecountync.gov/2332/Coronavirus-COVID-19';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("Covid-19 Cases"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
          color: Colors.grey[200],
          child: new Image.asset('assets/images/covid.jpeg'),
          alignment: Alignment.center,
        ),
          Center(
            child: SizedBox(
              //height: 400, // card height
              height: 325, // card height
              child: PageView.builder(
                itemCount: data == null ? 0 : data.length,
                controller: PageController(viewportFraction: 0.7),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.9,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            data[_index]["country"],
                            style: TextStyle(
                                fontSize: 32, color: Colors.blue[700]),
                            textAlign: TextAlign.center,
                          ),
                          new SizedBox(
                            height: 20.0,
                          ),
                          new Text(
                            "Cases: " + data[_index]["cases"].toString(),
                            style: TextStyle(
                                fontSize: 22, color: Colors.deepOrange[300]),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Today Cases: " +
                                data[_index]["todayCases"].toString(),
                            style: TextStyle(
                                fontSize: 22, color: Colors.deepOrange[300]),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Deaths: " + data[_index]["deaths"].toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Today Deaths: " +
                                data[_index]["todayDeaths"].toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Critical: " + data[_index]["critical"].toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Active: " + data[_index]["active"].toString(),
                            style: TextStyle(
                                fontSize: 22, color: Colors.green[300]),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Recovered: " +
                                data[_index]["recovered"].toString(),
                            style: TextStyle(
                                fontSize: 22, color: Colors.green[300]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          RaisedButton(
            onPressed: _launchURL,
            child: Text('Orange County COVID Resources'),
          ),
        ],
      ),
    );
  }
}
