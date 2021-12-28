import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:n2ma/ui/home.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickUpLocations extends StatefulWidget {
  State<StatefulWidget> createState() => _PickUpLocations();
  FirebaseUser user;

  PickUpLocations(this.user);
}

class _PickUpLocations extends State<PickUpLocations> {
  int value;
  var apiKey = "AIzaSyB9jxyGVzYKGznTwONZh11aZOb_4tmqpXQ";
  Color _borderColor = Colors.grey.withOpacity(.3);
  Firestore _firestore = Firestore.instance;
  SharedPreferences _prefs, _locationPrefs;
  String results = "";
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _locationPrefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs.getInt("py_key") == null ? 0 : _prefs.getInt("py_key");
    });
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  var _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: gray,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                top: 40.0, left: 20, right: 18, bottom: 8.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black45,
                    size: ScreenUtil().setWidth(90),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Pick up locations",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: ScreenUtil().setSp(66),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  onPressed: () =>
                      // Navigator.of(context).push(

                      //    MaterialPageRoute(builder:(context) => PlacePicker(
                      //   apiKey: apiKey ,
                      //    initialPosition: Home.kInitialPosition,
                      //    useCurrentLocation: true,
                      //    ))
                      // )

                      pickPlace(),
                  icon: Icon(
                    CupertinoIcons.add,
                    color: Colors.black45,
                    size: ScreenUtil().setWidth(90),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: ScreenUtil.screenWidth,
              height: MediaQuery.of(context).size.height,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: StreamBuilder(
                  stream: _firestore
                      .collection('User locations')
                      .document(widget.user.uid)
                      .collection(widget.user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return locationCard(
                            index, snapshot.data.documents[index], widget.user);
                      },
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  locationCard(index, DocumentSnapshot location, user) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _prefs.setInt("py_key", index);
          _locationPrefs.setString("keyLoc", location['address']);
         // DatabaseHelper().updateDefaultLocation(scaffoldKey, user, location, context);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: <Widget>[
            Radio(
              groupValue: _prefs.getInt("py_key") == null
                  ? 0
                  : _prefs.getInt("py_key"),
              value: index,
              onChanged: (index) {
                setState(() {
                  _prefs.setInt("py_key", index);
                  _locationPrefs.setString("keyLoc", location['address']);
                  // DatabaseHelper().updateDefaultLocation(scaffoldKey,user,location, context);
                });
               
              },
              activeColor: green,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  location.documentID,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(45)),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .64,
                  child: Text(
                    location['address'],
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
                onPressed: () => null,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black45,
                ))
          ],
        ),
      ),
    );
  }

  mapNameDialog(pickerResult) {
    showDialog(
        context: context,
        barrierDismissible: true,
        child: AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * .9,
            height: MediaQuery.of(context).size.width * .5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Save location"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: _borderColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(.2),
                            offset: Offset(1, 3),
                            blurRadius: 2,
                            spreadRadius: 1)
                      ]),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Save location: eg Home, workplace",
                        hintStyle: TextStyle(fontSize: ScreenUtil().setSp(35))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  color: green,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_textController.text == "" ||
                        _textController.text == null) {
                      setState(() {
                        _borderColor = Colors.red;
                      });
                    } else {
                      Navigator.pop(context);
                      DatabaseHelper().addPickupLocation(widget.user,
                          _textController.text, pickerResult, context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * .6,
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontSize: ScreenUtil().setSp(50)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  pickPlace() async {
    PlacePickerResult pickerResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlacePickerScreen(
                  googlePlacesApiKey: apiKey,
                  initialPosition: HomeScreen.kInitialPosition,
                  mainColor: green,
                  mapStrings: MapPickerStrings.english(),
                  placeAutoCompleteLanguage: 'en',
                )));
    setState(() {
      results = pickerResult.toString();
    });
    if (pickerResult != null) mapNameDialog(pickerResult);
  }
}
