import 'package:flutter/material.dart';
import 'package:tigerstogether/widgets/customWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// help reduce anxiety
// some kind of WEAR A MASK Icon
// getting latest info for WHO, and help
// Orange county: https://www.orangecountync.gov/2332/Coronavirus-COVID-19
// UNC Carolina Together: https://carolinatogether.unc.edu/dashboard/

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
      appBar: AppBar(
        leading: Padding(
          child: Image.asset('assets/images/icon-480.png'),
          padding: const EdgeInsets.all(8.0),
        ),
        backgroundColor: Colors.white,
        title: Text('COVID-19',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: SizedBox(
              //height: 400, // card height
              height: 280, // card height
              child: PageView.builder(
                itemCount: data == null ? 0 : data.length,
                controller: PageController(viewportFraction: 0.8),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.95,
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            data[_index]["country"],
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          new Text(
                            "Cases: " + data[_index]["cases"].toString(),
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Today Cases: " +
                                data[_index]["todayCases"].toString(),
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Deaths: " + data[_index]["deaths"].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Today Deaths: " +
                                data[_index]["todayDeaths"].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Critical: " + data[_index]["critical"].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Active: " + data[_index]["active"].toString(),
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          new SizedBox(
                            height: 5.0,
                          ),
                          new Text(
                            "Recovered: " +
                                data[_index]["recovered"].toString(),
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            color: Colors.white,
            onPressed: _launchURL,
            child: Text(
              'Orange County COVID Resources',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.grey[200],
            child: new Image.asset('assets/images/covid.jpeg'),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
