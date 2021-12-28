import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/database/authHelper.dart';
import 'package:n2ma/modals/userModal.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:n2ma/tools/customIcons.dart';
import 'package:n2ma/utils/clips.dart';

class UserAccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserAccessState();
}

enum userLog { signIn, signUp }

var logState;
bool obscure;
var strings;
User user;
Color shadowColor;
class _UserAccessState extends State<UserAccess> {
  var nameController, passController, emailController,phoneController = TextEditingController();
  AuthHelper authHelper;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    
    super.initState();
    authHelper = AuthHelper();
    logState = userLog.signIn;
    obscure = true;
     shadowColor = Colors.black12;
    user = User();

    strings = [
      "Welcome\nBack",
      "Create\nAccount",
      "Or sign up with",
      "Or sign In with",
      "Sign In",
      "Sign Up",
      "Already have an account",
      "I don't have an account"
    ];

  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child: topSection(),
              ),
              Positioned(
                top: screenSize.width *.25,
                left: 20,
                child: Text(
                  logState == userLog.signIn ? strings[0] : strings[1],
                  style: TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(100)),
                ),
              ),
              Positioned(
                right: 0,
                top: screenSize.width * .3,
                child: Container(
                    width: screenSize.width * .6,
                    height: screenSize.width * .42,
                    child: Hero(
                      tag: "appI",
                      child: Image.asset(
                        "assets/images/mangoes.png",
                        fit: BoxFit.fitHeight,
                      ),
                    )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * .7,
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        customDecoration(userEmailField()),
                        logState == userLog.signUp
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: customDecoration(userNameField()),
                              )
                            : Container(),
                        logState == userLog.signUp
                            ? customDecoration(fullNameField())
                            : Container(),
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                        ),
                        customDecoration(passwordField()),
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                        ),

                        logState == userLog.signUp
                            ? Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: customDecoration(phoneField()),
                        )
                            : Container(),
                        signInButton(),
                        SizedBox(height: ScreenUtil().setHeight(40)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              logState == userLog.signIn ? strings[6] : strings[7],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: ScreenUtil().setSp(35),),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(20)),
                            GestureDetector(
                                onTap: () {
                                  if (logState == userLog.signIn) {
                                    setState(() {
                                      logState = userLog.signUp;
                                    });
                                  } else {
                                    setState(() {
                                      logState = userLog.signIn;
                                    });
                                  }
                                },
                                child: Text(
                                  logState == userLog.signIn
                                      ? strings[5]
                                      : strings[4],
                                  style: TextStyle(
                                      color: green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(45),)))
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(60),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Divider(
                              thickness: 10.0,
                              color: Colors.black,
                              height: 4,
                            ),
                            Container(
                              child: Text(
                                strings[3].toString().toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black26),
                              ),
                            ),
                            Container()
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: facebookColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      CustomIcons.facebook,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Facebook",
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {},
                              child: Container(
                                width: ScreenUtil().setWidth(350),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: googleColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      CustomIcons.google,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Google",
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(.5),
                      size: ScreenUtil().setWidth(100),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userNameField() {
    return TextFormField(
      cursorColor: green,
      decoration: InputDecoration(
          hintText: "Username",
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.person_pin,
            color: green,
          )),
      onSaved: (val) => user.userName = val,
      validator: (val) => val =="" ? val : null,
    );
  }

  Widget fullNameField() {
    return TextFormField(
      cursorColor: green,
      decoration: InputDecoration(
          hintText: "Full Name",
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.person,
            color: green,
          )),
      onSaved: (val) => user.fullName = val,
      validator: (val) => val =="" ? val : null,
    );
  }

  Widget userEmailField() {
    return TextFormField(
      cursorColor: green,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Email Address",
        prefixIcon: Icon(
          Icons.email,
          color: green,
        ),
        border: InputBorder.none,
      ),
      onSaved: (val) => user.emailAddress = val,
      validator: (val) => val =="" ? val : null,
    );
  }

  Widget passwordField() {
    return TextFormField(
      cursorColor: green,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Password",
          prefixIcon: Icon(
            Icons.security,
            color: green,
          ),
          suffixIcon: IconButton(
            focusColor: green,
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                obscure = !obscure;
              });
            },
          )),
      obscureText: obscure,
      onSaved: (val) => user.password = val,
      validator: (val) => val =="" ? val : null,

    );
  }
  Widget phoneField() {
    return TextFormField(
      cursorColor: green,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Phone",
          prefixIcon: Icon(
            Icons.phone_iphone,
            color: green,
          ),),
      onSaved: (val) => user.telephone = val,
      validator: (val) => val =="" ? val : null,
    );
  }
  Widget signInButton() {
    return Container(
      width: ScreenUtil().uiWidthPx.toDouble(),
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, 1),
            spreadRadius: 1.0,
            blurRadius: 5,
          )
        ],
      ),
      child: FlatButton(
        onPressed: () => _submitForm(),
        child: Text(
          logState == userLog.signIn ? strings[4] : strings[5],
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(50)),
        ),
      ),
    );
  }

  Widget topSection() {
    return ClipPath(
      clipper: MyClip(),
      child: Container(
        color: green,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * .9,
      ),
    );
  }

  Widget customDecoration(child) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setHeight(1)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            spreadRadius: 1.0,
            blurRadius: 5,
          )
        ],
      ),
      child: child,
    );
  }

  _submitForm() {
    FormState formState = formKey.currentState;
    if(formState.validate()){
      formState.save();
      if(logState == userLog.signIn){
        authHelper.signInWithEmailAndPassword(user,context);
      }
      if(logState == userLog.signUp){
        authHelper.createUserWithEmailAndPassword(user,context);
      }
      formState.reset();
    }
  }


}
