import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/productModal.dart';
import 'package:n2ma/ui/colorSelector.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductDetail extends StatefulWidget {
  Product product;

  EditProductDetail({this.product});

  @override
  State<StatefulWidget> createState() => _EditProduct();
}

class _EditProduct extends State<EditProductDetail> {
  File imageHolder;
  var _itemName, variation;
  Color _itemColor;
  Product _product;
  List<ProductVariation> varList = [];
  List _unitOfMeasure = ["Weight","Size","Unit"];
  List _typeList = ["Vegetable","Fruit"];
  var _currentMeasure = "";
  var _productType = "";
  Map newData = {};
  TextEditingController amountController = TextEditingController();
  TextEditingController variationTitleController = TextEditingController();
  @override
  void initState() {
    _itemName = widget.product.name;
    _product = widget.product;
    _itemColor = Color(int.parse( _product.color.toString().substring(6,16)));
    addVariations();
    _currentMeasure = _product.unitOfMeasure;
    _productType = _product.type;
    super.initState();

  }

  pushToDB(currentUser){
     setState((){
      newData = {
        "Product Name": _itemName,
        "Type": _productType,
        "Unit of Measure": _currentMeasure,
        "Background Color": _itemColor,
        "Product Variations": varList,
      };
    });

     DatabaseHelper(currentUser: currentUser.uid).editProduct(context: context,product: _product, newData: newData,imageFile: imageHolder);


  }

  addVariations(){
    _product.variations.forEach((element) {
      setState(() {
        varList.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<FirebaseUser>(context);
    ScreenUtil.init(context, allowFontScaling: true);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: _itemColor,
        child: Column(
          children: <Widget>[

            Expanded(
              child: Container(
                color: Colors.white,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [

                      Container(
                        color: _itemColor,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Stack(
                          children: [
                            Container(
                              width: screenSize.width,
                              height: screenSize.width * 1,

                            ),
                            Positioned(
                              top: screenSize.width *.2, left: 0,
                              child: Container(
                                width: screenSize.width,
                                height: screenSize.width * 0.8,
                                decoration: BoxDecoration(
                                    color: _itemColor,
                                    image: DecorationImage(
                                        image: imageHolder == null
                                            ? NetworkImage(_product.image)
                                            : FileImage(imageHolder),
                                        fit: BoxFit.fitHeight)),
                              ),
                            ),
                            Positioned(
                                top: screenSize.width * .30,
                                right: screenSize.width * .02,
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: Icon(Icons.add_a_photo,color: Colors.black26,size: screenSize.width * .1,),
                                  onPressed: () => changeImage(),
                                )),
                            Positioned(
                                top: screenSize.width * .45,
                                right: screenSize.width * .02,
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: Icon(Icons.format_color_fill,color: Colors.black26,size: screenSize.width * .1,),
                                  onPressed: () async{
                                    var _tempColor = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>  ColorSelectr(_itemColor, imageHolder),
                                    ));
                                    setState(() {
                                      _itemColor = _tempColor;
                                    });

                                  },
                                )),
                            Positioned(
                              top: screenSize.width *.12,
                              left: screenSize.width *.02,
                              width: screenSize.width,
                              child:Row(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: ScreenUtil().setWidth(70),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      Text("Edit product",
                                          style: nameStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setSp(70),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Item Name", style: textStyle(),),
                            SizedBox(height: 5,),
                            TextFormField(
                              enabled: false,
                              initialValue: _itemName,
                              onChanged: (value) => setState((){
                                _itemName = value;
                              }),
                            ),
                            SizedBox(height: 20,),
                            Row(children: [Text("Measure:",style: textStyle(),),SizedBox(width: screenSize.width * .18,),_unitSelection()],),

                            SizedBox(height: 20,),
                            Row(children: [Text("Type:",style: textStyle(),),SizedBox(width: screenSize.width * .29,),_typeSelect()],),
                            SizedBox(height: 20,),
                            Divider(),
                            SizedBox(height: 20,),
                            Text("Variations", style: textStyle(),),
                            SizedBox(height: 10,),
                            variationForm(),
                            SizedBox(height: 20,),
                            Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                onPressed: ()=> _popVariationForm(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                                  child: Text("Add variation",style: TextStyle(color: Colors.black45)),decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12)
                                ),),
                              ),
                            ),

                          ],
                        ),
                      )

                    ],
                  ),
                ),
              )
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              color: Colors.white,
              child: FlatButton(
                onPressed: () =>  pushToDB(currentUser) ,
                textColor: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  color: green,
                  child: Text('Save changes',
                      style: TextStyle(fontSize: ScreenUtil().setSp(55))),
                  width: screenSize.width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  textStyle() => TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Colors.black12,
  );

  containerDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.black12),
      color: Colors.white,
    );
  }

  variationForm() {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: varList.length,
            itemBuilder: (context, position) {
              return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      varList[position].name,
                      style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .2,
                    ),
                    Expanded(child: Text(varList[position].price.toString(),textAlign: TextAlign.right,)),
                    Spacer(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit,color: Colors.black45,size: MediaQuery.of(context).size.width * .06,),
                            onPressed: () => null,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black45,size: MediaQuery.of(context).size.width * .06),
                            onPressed: () => setState((){
                              varList.removeAt(position);
                            }),
                          )
                        ]),
                  ],
                ),

              ]));
            })
        );
  }

  _unitSelection(){
    return DropdownButton(
      value: _currentMeasure,
      hint: Text("Measurement"),
      onChanged: (value) => setState((){
        _currentMeasure = value;
      }), items: _unitOfMeasure.map((item){
        return DropdownMenuItem(
          value: item,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.toString()),
          ),
        );
      }).toList(),

    );
  }


  _typeSelect(){
    return DropdownButton(
      hint: Text("Select product type"),
      onChanged: (value) => setState((){
        _productType = value;
      }),
      value: _productType,
      items: _typeList.map((item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(item.toString()),
        ),
      )).toList(),
    );
  }

  _popVariationForm(){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Add variation"),
        content: Container(
          height: MediaQuery.of(context).size.width * .5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: variationTitleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Variation Title"),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Amount"),
              ),
              SizedBox(height:20),
              RaisedButton(
                onPressed: () => setState((){
                  varList.add(ProductVariation(name: variationTitleController.text,price: amountController.text));
                  variationTitleController.clear();
                  amountController.clear();
                }),
                child: Text("Add"),
              )
              ],
          ),
        ),
      );
    });
  }

  changeImage() async {
    try {
      var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageHolder = imageFile;
      });
    } catch (e) {
      print("Something went wrong");
    }
  }


}
