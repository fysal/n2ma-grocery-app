import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/productModal.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget{
State<StatefulWidget> createState() => _Favorite();

}

class _Favorite extends State<Favorite>{
  var db = Firestore.instance;
  Product _product;

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    var fav = Provider.of<FavoriteNotifier>(context);
    ScreenUtil.init(context);
    Size screensize = MediaQuery.of(context).size;
    return user != null ?  Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("My favorites",
            style: nameStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(70)),),
          Expanded(
            child: StreamBuilder(
              stream: db.collection('Favorites').document(user.uid).collection(user.uid).snapshots(),
              builder: (context, snapshot){
                return snapshot.data == null || snapshot.hasError ? Container(child:Text("There is an error")) : snapshot != null && snapshot.data.documents.length > 0 ?
                    Container( height: screensize.height,
                      child: MediaQuery.removePadding(context: context, removeTop: true,
                        child: ListView.builder(itemCount: snapshot.data.documents.length,shrinkWrap: true,itemBuilder: (context, position){
                        return StreamBuilder(stream: db.collection('Products')
                            .where(FieldPath.documentId, isEqualTo: snapshot.data.documents[position]['item'] ).snapshots(),
                        builder: (context, datasnap){
                          return datasnap.data == null || datasnap.hasError ? Center(child: CircularProgressIndicator()) :
                              datasnap != null && datasnap.data.documents.length > 0 ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: datasnap.data.documents.map<Widget>((document){
                              _product = Product.fromFirebase(document);
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(color: Colors.black26.withOpacity(.1), offset: Offset(0,0), spreadRadius: 1, blurRadius: 3)
                                ]),
                                
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                    Row(children: <Widget>[
                                        Image.network(_product.image,fit:BoxFit.fitWidth, width: screensize.width * .2, height: screensize.width *.2,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(_product.name, style:  titleStyles,),
                                            Text(_product.type),
                                            Text("Ugx ${_product.variations[0].price}")
                                          ],
                                        ),
                                      ],
                                    ),

                                    FlatButton(child: Text("Add to cart"), onPressed:() => null,),

                                    Material(
                                      elevation: 1.0,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10) ,
                                      child: IconButton(onPressed:() => DatabaseHelper().removeFromFavorites(_product, context, fav)
                                        ,icon: Icon(Icons.favorite,color: Colors.red,),),
                                    )
                                  ],
                                ),
                              );
                                }).toList()
                              ) :
                                  Container();
                        },);
                    }),
                      ),) : Container(child: Center(child: Text("You have nothing in favorites"),),);
              },
            ),
          ),
        ],
      ),
    ): Container(child: Text('Your not logged in'),);
    
    throw UnimplementedError();
  }

}