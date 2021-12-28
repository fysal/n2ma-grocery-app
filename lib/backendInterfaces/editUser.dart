import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/userModal.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:provider/provider.dart';

class EditUserData extends StatefulWidget {
  State<StatefulWidget> createState() => _EditUserData();
} 

class _EditUserData extends State<EditUserData> {
  User _userModal = new User();
  Firestore db = Firestore.instance;
  var _documentReference;
  bool hidePass = true;
  GlobalKey<FormState> formKey = GlobalKey();
   TextEditingController passController  = TextEditingController();

  _getUserData(FirebaseUser currentUser) async {
    try {
      _documentReference = await db.collection('Users').document(currentUser.uid).get();
      setState(() {
        _userModal = User.map(_documentReference);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final currentUser = Provider.of<FirebaseUser>(context);
    _getUserData(currentUser);
   

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: ScreenUtil().setHeight(80)),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: ScreenUtil().setHeight(80),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Edit profile",
                          style: nameStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(70)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(50)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: _decoration(),
                          child: TextFormField(
                            initialValue: _userModal.emailAddress,
                            decoration: _inputDecoration(
                                hint: _userModal.emailAddress, icon: Icon(Icons.email)),
                            onSaved: (val) => val != null
                                ? setState(() {
                                    val = _userModal.emailAddress;
                                  })
                                : _userModal.emailAddress = val,
                            validator: (val){
                             if(val == null || val == "")
                               return "Field can't be empty";
                            }
                                 ,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: _decoration(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            initialValue: _userModal.telephone,
                            decoration: _inputDecoration(
                                hint: _userModal.telephone, icon: Icon(Icons.phone)),
                            onSaved: (val) => 
                                 setState(() {
                                    val = _userModal.telephone;
                                  }),
                            validator: (val) {
                              if(val == null || val =="")
                              return  "Field can't be empty";
                            }
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: _decoration(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            initialValue: _userModal.fullName,
                            decoration: _inputDecoration(
                                hint: _userModal.fullName, icon: Icon(Icons.person)),
                            onSaved: (val) => val != null
                                ? setState(() {
                                    val = _userModal.fullName;
                                  })
                                : _userModal.fullName = val,
                            validator: (val) {
                              if( val == null || val == "")
                               return "Your name is required";
                            }
                               
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: _decoration(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            controller:  passController,
                            cursorColor: green,
                            obscureText: hidePass,
                            decoration: _inputDecoration(
                                hint: "Password", icon: Icon(Icons.lock)),
                            validator: (password){
                              if(password == null || password == "")
                              return "Password required";
                            }
              
                                
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: _decoration(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                        cursorColor: green,
                        onChanged: (confirmation) {

                        },
                        obscureText: hidePass,
                        decoration: _inputDecoration(
                        hint: "Re-enter password", icon: Icon(Icons.lock)),
                        onSaved: (confirmation) =>
                                 setState(() {
                                    confirmation = _userModal.password;
                                  }),
                        validator: (confirmation) {
                          if(confirmation == null || confirmation == "")
                             return "Password confrimation is required";
                          if(confirmation.toString() != passController.text)
                            return "Passwords do not match";
                          },
                           
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () => _submitForm(currentUser, _userModal, _documentReference),
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: green,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(50),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  _submitForm(
      FirebaseUser currentUser, User _userModal, DocumentSnapshot snapshot) {
    FormState formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      print("Forms has been saved");

//     DatabaseHelper().updateUserData(currentUser, _userModal, snapshot);
    }
  }

  _inputDecoration({String hint, icon}) {
    return InputDecoration(
        border: InputBorder.none,
        focusColor: green,
        hoverColor: green,
        icon: icon,
        hintText: hint);
  }

  _decoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.black.withOpacity(.2)),
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    );
  }
}
