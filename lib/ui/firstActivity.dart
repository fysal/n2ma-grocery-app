
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/ui/groceryDetails.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/productModal.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/modals/itemModal.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';



class FirstActivity extends StatefulWidget {
  @override
  _FirstActivityState createState() => _FirstActivityState();
}
    Firestore _firestore = Firestore.instance;

class _FirstActivityState extends State<FirstActivity> {
  List _tabs = [];
  int currentTab = 0;
  List<Widget> _tabWidgets = [];
  Widget _tabWidget;
  
  void initState() {
    _tabs = ['Fruits', 'Vegetables'];
    _tabWidgets = [_FruitsTab(), _VegeTab() ];
    _tabWidget = _tabWidgets[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: 5
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _tabbedList(),
            ),
          ),
          Expanded(
            child: Container(
//              color: Colors.blueGrey.withOpacity(.2),
              child: _tabWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget tabsWidget(bool isActive, String tabString, int position) { 
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTab = position;
          _tabWidget = _tabWidgets[position];
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          child: Text(
            tabString,
            style: isActive ? tabStyleActive.copyWith(fontSize: ScreenUtil().setSp(78) )
                : tabStyle.copyWith(fontSize: ScreenUtil().setSp(78)),
          ),
        ),
      ),
    );
  }

  List<Widget> _tabbedList() {
    List<Widget> _tabList = [];
    for (int i = 0; i < _tabs.length; i++) {
      _tabList.add(tabsWidget(currentTab == i ? true : false, _tabs[i], i));
    }
    return _tabList;
  }
}


class _FruitsTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: StreamBuilder(
        stream: _firestore.collection('Products').where('Type', isEqualTo: 'Fruit')
        .snapshots(),
        builder: (context, snapshot){
          if(snapshot.data == null)
            return Center(child: CircularProgressIndicator(),);
        return fruitVegGrid(snapshot, context);
      },)
    );
  }
}

class _VegeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return StreamBuilder(
    stream: _firestore.collection('Products').where('Type', isEqualTo: 'Vegetable')
    .snapshots(),
    builder: (context, snapshot){
      if(snapshot.data == null)
        return Center(child: CircularProgressIndicator(),);

      return fruitVegGrid(snapshot, context);
    },
    );
  }
}


Widget fruitVegGrid(snapshot,context) {
  var currentUser = Provider.of<FirebaseUser>(context);
  var favNotify = Provider.of<FavoriteNotifier>(context);
  return StaggeredGridView.countBuilder(
    shrinkWrap: true,
    itemCount: snapshot.data.documents.length,
    crossAxisCount: 2,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, int position) {
      Product _product = Product.fromFirebase(snapshot.data.documents[position]);
      Size screenSize = MediaQuery.of(context).size;

      return GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GroceryDetails(_product, position);
            })),
        child: Hero(
          tag: position,
          child: Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: _product.color != null ? Color(int.parse(_product.color.substring(6,16)))  : Colors.white,
            ),
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Positioned(
                  top: screenSize.width / 12,
                  left: 0,
                  width: screenSize.width / 2,
                  child: Container(
                      height: screenSize.height / 4,
                      child: Image.network(_product.image)),
                ),
                Positioned(
                    width: screenSize.width * 0.465,
                    bottom: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        _product.name,
                        style: nameStyle.copyWith(fontSize: ScreenUtil().setSp(48)),
                      ),
                    )),
                Positioned(
                  width: screenSize.width,
                  left: 0,
                  bottom: 20,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Sh ${_product.variations.elementAt(0).price}",
                                style: priceStyle.copyWith(fontSize: 20),
                              )),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            child: Text(" / ${_product.unitOfMeasure}"),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      if(favNotify.favList.contains(_product.name)){
                        DatabaseHelper(currentUser: currentUser.uid).addToFavorite(_product, context, favNotify);
                        showSnackBar(text: "${_product.name} added to favorites");
                      }else{
                        DatabaseHelper(currentUser: currentUser.uid).removeFromFavorites(_product, context, favNotify);
                        showSnackBar(text: "${_product.name} removed from favorites");
                      }

                    },
                    icon: favNotify.favList.contains(_product.name) ?  Icon(Icons.favorite,size: ScreenUtil().setWidth(80), color: Colors.deepOrange,)
                        : Icon(Icons.favorite_border,size: ScreenUtil().setWidth(80),color: Colors.black26,),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
    staggeredTileBuilder: (int index) =>
    new StaggeredTile.count(1, index.isEven ? 1.8 : 1.5),
    mainAxisSpacing: 2,
    crossAxisSpacing: 2,
    padding: EdgeInsets.only(top: 10),
  );
}


showSnackBar({String text}){
return SnackBar(content: Text(text),);
}

