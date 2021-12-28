import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/database/authHelper.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/userModal.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:n2ma/backendInterfaces/editUser.dart';
import 'package:n2ma/backendInterfaces/singin-signup.dart';
import 'package:provider/provider.dart';


class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User user;
  String loginString = "Log in";
  AuthHelper _authHelper;
  Firestore firestore;

  @override
  void initState() {
    super.initState();
    _authHelper = AuthHelper();
    firestore = Firestore.instance;
    user = User();
  }

  @override
  Widget build(BuildContext context) {
    final userStream = Provider.of<FirebaseUser>(context, listen: true);
    Size screenSize = MediaQuery.of(context).size;
    ScreenUtil.init(context, allowFontScaling: true);
    return userStream != null
        ? StreamBuilder(
            stream: firestore
                .collection('Users')
                .document(userStream.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = User.map(snapshot.data);
                return profileWidget(
                    size: screenSize, uStream: userStream, context: context);
              }

              return Container();
            })
        : profileWidget(
            size: screenSize, uStream: userStream, context: context);
  }
  profileWidget({Size size, FirebaseUser uStream, BuildContext context}) {
    Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height / 1.45,
            color: softerWhite,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: size.width,
                    height: size.height / 2,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [green, green],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                ),
                Positioned(
                  top: size.width * .15,
                  width: size.width,
                  child: Center(
                    child: Container(
                      width: size.width * .3,
                      height: size.width * .3,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 3),
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image:uStream != null ? NetworkImage(
                                  user.userAvatar ?? 'default'):
                              AssetImage("assets/images/man.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
               uStream != null ? Positioned(
                  right: screenSize.width * .32,
                  top: screenSize.width * .33,
                  child: GestureDetector(
                    onTap: () => DatabaseHelper.uploadImage(uStream.uid, context),
                    child: Container(
                      width:screenSize.width * .1,
                       height: screenSize.width * .1,
                       decoration:BoxDecoration(
                         border: Border.all(color: Colors.white,width: 2),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(.2),
                             offset: Offset(0,0),
                             spreadRadius: 2,
                             blurRadius: 2
                           )
                         ],
                         color: gray,
                         borderRadius: BorderRadius.circular(50),
                       ),
                        child: Icon(
                            Icons.add,color: Colors.black38,)),
                  ),
                ) : Container(),
                Positioned(
                  top: size.width * .5,
                  width: size.width,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          uStream != null ? user.fullName : "Full Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(60),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          uStream != null ? user.emailAddress : "Email address",
                          style: profText.copyWith(
                              fontSize: ScreenUtil().setSp(45),
                              letterSpacing: 1),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(uStream != null ? user.telephone : "Telephone",
                            style: profText.copyWith(
                                fontSize: ScreenUtil().setSp(45))),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: size.height / 2.13,
                  width: size.width,
                  child: Center(
                    child: Container(
                      width: size.width * .4,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    uStream != null ? EditUserData() : UserAccess())),
                        child: Material(
                          color: Colors.white,
                          elevation: 10,
                          borderRadius: BorderRadius.circular(18),
                          child: Center(
                              child: Text(
                            uStream != null ? "Edit profile" : "Create Account",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height / 1.8,
                  height: size.height,
                  width: size.width,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(mainAxisSize: MainAxisSize.max, children: <
                        Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: size.width / 3.7,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  StreamBuilder(
                                    stream: firestore.collection("Orders")
                                        .document(uStream.uid)
                                        .collection(uStream.uid)
                                    .snapshots(),
                                    builder: (context, snapshot) => Text(snapshot.data != null ?
                                    snapshot.data.documents.length.toString() :
                                        "0",
                                        style: stats.copyWith(
                                            fontSize: ScreenUtil().setSp(100))),
                                  ),

                                  Text(
                                    "Orders",
                                    style: statsLabel.copyWith(
                                      fontSize: ScreenUtil().setSp(40),
                                    ),
                                  ),
                                  Container(
                                    height: 6,
                                    width: size.width / 6,
                                    decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.black,
                                              Colors.transparent
                                            ],
                                            center: Alignment.center,
                                            stops: [1.0, 20.0, 0.0],
                                            focalRadius: 10,
                                            radius: 10)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  uStream == null
                                      ? Text("0",
                                          style: stats.copyWith(
                                              fontSize:
                                                  ScreenUtil().setSp(100)))
                                      : StreamBuilder(
                                          stream: firestore
                                              .collection("Cart")
                                              .document(uStream.uid)
                                              .collection(uStream.uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            return Text(
                                                snapshot.hasData
                                                    ? snapshot
                                                        .data.documents.length
                                                        .toString()
                                                    : "0",
                                                style: stats.copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(100)));
                                          }),
                                  Text(
                                    "Item in cart",
                                    style: statsLabel.copyWith(
                                      fontSize: ScreenUtil().setSp(40),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("0",
                                      style: stats.copyWith(
                                          fontSize: ScreenUtil().setSp(100))),
                                  Text(
                                    "Wishlist",
                                    style: statsLabel.copyWith(
                                      fontSize: ScreenUtil().setSp(40),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ], // end Stack
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(
                    Icons.payment,
                  ),
                  title: Text("Payment"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(
                    Icons.settings,
                  ),
                  title: Text("Settings"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(Icons.help),
                  title: Text("Help & support"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(Icons.help),
                  title: Text("Tell a friend"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  onTap: () => null,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                  child: Center(
                    child: FlatButton(
                      onPressed: () async {
                        uStream != null
                            ? await _authHelper.signOut(context)
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserAccess()));
                      },
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          width: size.width / 2.5,
                          child: Text(
                            uStream != null ? "Sign Out" : "Sign In",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                fontWeight: FontWeight.w500,
                                color: green),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
