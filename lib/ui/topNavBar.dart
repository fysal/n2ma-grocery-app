import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/ui/home.dart';
import 'package:n2ma/modals/userModal.dart';
import 'package:n2ma/tools/customIcons.dart';
import 'package:n2ma/backendInterfaces/singin-signup.dart';
import 'package:provider/provider.dart';

class TopNavBar extends StatefulWidget {
  @override
  _TopNavBarState createState() => _TopNavBarState();

}

class _TopNavBarState extends State<TopNavBar> {

  String userImage;
  FirebaseUser userLoggedIn;
  User user = User();
  var uStream;

  @override
  Widget build(BuildContext context) {
    userLoggedIn = Provider.of<FirebaseUser>(context, listen: true,);
    if(userLoggedIn != null)
      uStream = Firestore.instance.collection('Users').document(userLoggedIn.uid).snapshots();

    return StreamBuilder(
      stream: uStream,
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot != null)
        user = User.map(snapshot.data);
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 18, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    CustomIcons.menu,
                    size: ScreenUtil().setWidth(75),
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        size: ScreenUtil().setWidth(75),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 5,),
                    userLoggedIn == null ? GestureDetector(
                      onTap: ()  => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => UserAccess()
                      )),
                      child: ClipOval(
                        child: Container(
                            width: ScreenUtil().setWidth(90),
                            height: ScreenUtil().setWidth(90),
                            color: Colors.blueGrey,
                            child: userImage == null ? Icon(
                              CustomIcons.user_alt_3,
                              color: Colors.white,
                              size: ScreenUtil().setWidth(50),
                            ) : Image.asset("assets/images/man.png")),),)
                        : GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(parsedIndex: 1))),
                      child: ClipOval(
                        child: Container(
                            width: ScreenUtil().setWidth(90),
                            height: ScreenUtil().setWidth(90),
                            color: Colors.blueGrey,
                            child: userImage == "assets/images/man.png"
                                ? Icon(
                              CustomIcons.user_alt_3,
                              color: Colors.white,
                              size: ScreenUtil().setWidth(50),
                            )
                                : snapshot.data != null ? FadeInImage(
                              placeholder: AssetImage("assets/images/chameleon.jpg"),
                              fit: BoxFit.cover,

                              image: CacheImage(user.userAvatar,),
                            ) :  Image.asset("assets/images/man.png",fit: BoxFit.cover,) ) ,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },

    );
  }
}
