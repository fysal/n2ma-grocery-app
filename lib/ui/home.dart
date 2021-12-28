import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:n2ma/ui/cart.dart';
import 'package:n2ma/ui/old_cart.dart';
import 'package:n2ma/ui/favorite.dart';
import 'package:n2ma/ui/ordersScreen.dart';
import 'package:n2ma/ui/userProfile.dart';
import 'package:n2ma/backendInterfaces/addproduct.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/userModal.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:n2ma/tools/customIcons.dart';
import 'package:n2ma/ui/topNavBar.dart';
import 'package:provider/provider.dart';
import 'firstActivity.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  int parsedIndex;
  HomeScreen({this.parsedIndex});
  static final kInitialPosition = LatLng(0.3476, 32.5825);
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex;
  Color navBarBg = Colors.lightGreen;
  List<Widget> pages = [];
  Widget currentPage;
  User user;
  bool showNav;
  User loggedInUser;
  @override
  void initState(){
    pages = [FirstActivity(), UserProfile(),Favorite(), OrdersScreen(), Cart()];
    if(widget.parsedIndex == null){
      currentPageIndex = 0;
      currentPage = pages[0];

    }else{
      setState(() {
        currentPageIndex = widget.parsedIndex;
        currentPage = pages[currentPageIndex];
      });
    }
    showNav = true;
    super.initState();
  }

  _onTapped(index) {
    setState(() {
      currentPage = pages[index];
      currentPageIndex = index;
      if(index == 1){
        showNav = false;
      }else{
        showNav = true;
      }
    });
  }

  @override
  Widget build(buildContext) {
    ScreenUtil.init(context);
    double iconSize = ScreenUtil().setWidth(60);
    var favNotify = Provider.of<FavoriteNotifier>(context);
//    var currentUser = Provider.of<FirebaseUser>(context);
//    DatabaseHelper(currentUser: currentUser.uid).getAllFavorites(context, favNotify);
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showNav ? TopNavBar() : Container(),
            Expanded(
              child: currentPage,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: green,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct())),
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: bottomBar(iconSize),

    );
  }
  bottomBar(iconSize){
    return  BubbleBottomBar(
      currentIndex: currentPageIndex,
      onTap: _onTapped,
      opacity: 1,
      elevation: 100,
      hasInk: true,
      hasNotch: true,
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
          backgroundColor: green,
          title: Text("Home",
              style:
              activeNavStyle.copyWith(fontSize: ScreenUtil().setSp(40))),
          icon: Icon(
            Icons.home,
            color: Colors.black26,
            size: iconSize,
          ),
          activeIcon: Icon(Icons.home, color: Colors.white, size: iconSize),
        ),
        BubbleBottomBarItem(
            backgroundColor: green,
            icon: Icon(
              CustomIcons.user_alt_3,
              color: Colors.black26,
              size: iconSize,
            ),
            title: Text("Profile",
                style: activeNavStyle.copyWith(
                    fontSize: ScreenUtil().setSp(40))),
            activeIcon: Icon(
              CustomIcons.user_alt_3,
              color: Colors.white,
              size: iconSize,
            )),
        BubbleBottomBarItem(
            backgroundColor: green,
            icon: Icon(
              Icons.favorite,
              color: Colors.black26,
              size: iconSize,
            ),
            title: Text("Favourite",
                style: activeNavStyle.copyWith(
                    fontSize: ScreenUtil().setSp(40))),
            activeIcon: Icon(
              Icons.favorite
              ,
              color: Colors.white,
              size: iconSize,
            )),
        BubbleBottomBarItem(
            backgroundColor: green,
            icon: Icon(
              Icons.business_center,
              color: Colors.black26,
              size: iconSize,
            ),
            title: Text("Orders",
                style: activeNavStyle.copyWith(
                    fontSize: ScreenUtil().setSp(40))),
            activeIcon: Icon(
              Icons.business_center,
              color: Colors.white,
              size: iconSize,
            )),
        BubbleBottomBarItem(
            backgroundColor: green,
            icon: Icon(
              CustomIcons.basket,
              color: Colors.black26,
              size: iconSize,
            ),
            title: Text("Cart",
                style: activeNavStyle.copyWith(
                    fontSize: ScreenUtil().setSp(40))),
            activeIcon: Icon(
              CustomIcons.cart,
              color: Colors.white,
              size: iconSize,
            ))
      ],
    );
  }
}
