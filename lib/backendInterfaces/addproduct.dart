import 'dart:io';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/ui/colorSelector.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/productModal.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {State<StatefulWidget> createState() => _AddProduct();}

class _AddProduct extends State<AddProduct> {

  GlobalKey<FormState> _formKey = GlobalKey();
  File _image;
  String _fileName = "";
  var _filePath;
  String _defaultValue = "Fruit";
  double _listHeight;
  String _unitType;
  Product _product = Product();
  Color _initialColor = green;
  Color _btnColor = green;
  var decodeImage;
  var _imgSize;

  List<String> _prodCat = ["Fruit", "Vegetable"];
  List<String> _unitOfMeasure = ["Weight", "Size", "Unit","Bundle","Bag"];
  // List<String> __weightsMeasure = ["Kg","Gm"];
  String _chosenItem;

  ProductVariation productVariation = ProductVariation();
  TextEditingController varLabel = TextEditingController();
  TextEditingController varPrice = TextEditingController();

  @override
  void initState() {
    _product = Product();
    _product.type = _defaultValue;
    _product.unitOfMeasure = _unitType;
    _chosenItem = _unitOfMeasure[1];
    super.initState();
  }

  selectList(List listItems){
    return DropdownButtonHideUnderline(
          child: DropdownButton(
        hint: Text("Select unit of measure"),
        onChanged: (value) => setState((){
          _chosenItem = value;}) ,
        
        value: _chosenItem,
        icon: Icon(Icons.keyboard_arrow_down),

        items: listItems.map((item){
         return DropdownMenuItem(
           value: item,
           child: Text(item.toString()),);
        }).toList(),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    Size screenSize = MediaQuery.of(context).size;
    var tempList = Provider.of<VariationNotifier>(context);
    _listHeight = tempList.tempVariation.length * .17;
    _product.variations = tempList.tempVariation;
    _product.color = _initialColor;
    _product.unitOfMeasure = _chosenItem;
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 40,),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                "Add product",
                style: titleStyles.copyWith(
                  fontSize: ScreenUtil().setSp(66),
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                         GestureDetector(
                           onTap: ()=> pickImageFromDevice(),
                              child: Container(
                              decoration: boxDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: screenSize.width * .23,
                                      height: screenSize.width * .23,
                                      decoration: BoxDecoration(
                                          color: _initialColor,
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: _image != null
                                                  ? FileImage(_image)
                                                  : AssetImage(
                                                      'assets/images/chameleon.jpg'))),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Name:"),
                                              SizedBox(
                                                width: 5, 
                                              ),
                                              Container(
                                                width: screenSize.width * .35,
                                                child: Text(_fileName, overflow: TextOverflow.ellipsis,

                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "File Size:",
                                                style: TextStyle(),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              _image != null
                                                  ? Text(_imgSize.toString())
                                                  : Text("20 MB",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Resolution:",
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              _image != null ? Text(
                                                      "${decodeImage.width} x ${decodeImage.height}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  : Text(
                                                      "300x400",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Path:",
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              _image != null
                                                  ? Container(
                                                      width:
                                                          screenSize.width * .38,
                                                      child: Text(_filePath,
                                                          overflow: TextOverflow
                                                              .ellipsis))
                                                  : Text(
                                                      "",
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black38,
                                      height: 100,
                                      thickness: 5,
                                    ),
                                    IconButton(
                                      onPressed: ()=> pickImageFromDevice(),
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: boxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Text("Product Title",
                                      style: nameStyleDetail.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(40))),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black38),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          border: InputBorder.none),

                                      onSaved: (val) => _product.name = val,
                                      validator: (val) => val != "" ? null : "Field is requiered",
                                      autovalidate: false,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ), // end CAre
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: boxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    "Product Type",
                                    style: nameStyleDetail.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(40)),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(
                                          groupValue: _defaultValue,
                                          value: "Fruit",
                                          activeColor: _initialColor,
                                          onChanged: (value) {
                                            onRadioTapped(value);
                                          },
                                        ),
                                        Text("Fruit"),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          groupValue: _defaultValue,
                                          value: "Vegetable",
                                          activeColor: _initialColor,
                                          onChanged: (value) {
                                            onRadioTapped(value);
                                          },
                                        ),
                                        Text("Vegetable")
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Select Variation Type",style: nameStyleDetail.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenUtil().setSp(40)),),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: boxDecoration(),
                            child: selectList(_unitOfMeasure)
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Product Variations",
                              style: nameStyleDetail.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenUtil().setSp(40))),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              tempList.tempVariation.length < 1
                                  ? DottedBorder(
                                      radius: Radius.circular(10),
                                      color: Colors.blueGrey.withOpacity(0.4),
                                      child: GestureDetector(
                                        onTap: () =>
                                            sizeVariationWidget(tempList),
                                        child: Container(
                                            color: Colors.white,
                                            alignment: Alignment.center,
                                            width: screenSize.width,
                                            height: screenSize.width * .2,
                                            child:
                                                Text("Tap to add variation ")),
                                      ),
                                    )
                                  : Container(
                                      width: screenSize.width,
                                      height: screenSize.width * _listHeight,
                                      child: MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              tempList.tempVariation.length,
                                          itemBuilder: (context, index) {
                                            return variationsWidget(
                                                tempList.tempVariation[index],
                                                index,
                                                tempList);
                                          },
                                        ),
                                      ),
                                    ),
                              FlatButton(
                                onPressed: () {
                                  sizeVariationWidget(tempList);
                                },
                                child: tempList.tempVariation.length > 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: gray),
                                        child: Text(
                                          "Add another variation",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ))
                                    : Container(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    var tempColor = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ColorSelectr(_initialColor, _image)));
                    setState(() {
                      _initialColor = tempColor;
                      _btnColor = tempColor;
                    });
                  },
                  child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 0))
                          ],
                          gradient: LinearGradient(colors: [
                            _initialColor,
                            _initialColor.withOpacity(.6),
                            _initialColor.withOpacity(.3)
                          ]),
                          shape: BoxShape.circle)),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: _btnColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _onSubmit();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    width: screenSize.width * .6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Upload product".toUpperCase(),
                          style: TextStyle(fontSize: ScreenUtil().setSp(45)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white54,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  onRadioTapped(value) {
    setState(() {
      _defaultValue = value;
      _product.type = _defaultValue;
    });
  }

  variationsWidget(ProductVariation variation, index, tempList) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
      decoration: boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            variation.name,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(45)),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "UGX ${variation.price}",
            style: TextStyle(fontSize: ScreenUtil().setSp(45)),
          ),
          Expanded(
            child: Container(
              width: 100,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                tempList.tempVariation.removeAt(index);
              });
            },
            icon: Icon(
              Icons.clear,
              color: Colors.black38,
            ),
          )
        ],
      ),
    );
  }

  sizeVariationWidget(var tempList) {
    showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.width * .5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Add variation",
                    style: TextStyle(fontSize: ScreenUtil().setSp(50))),
                SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  width: MediaQuery.of(context).size.width * .69,
                  height: MediaQuery.of(context).size.width * .1,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _chosenItem == _unitOfMeasure[1] ?  TextField(
                    controller: varLabel,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Title"),
                  ): _chosenItem == _unitOfMeasure[0] ? Text("KG"):
                     _chosenItem == _unitOfMeasure[2] ? Text(_unitOfMeasure[2]) : 
                     _chosenItem == _unitOfMeasure[3] ? Text(_unitOfMeasure[3]) : Text(_unitOfMeasure[4]) ,
                ),
                SizedBox(height: 20), 
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  width: MediaQuery.of(context).size.width * .69,
                  height: MediaQuery.of(context).size.width * .1,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: varPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Price"),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  color: green,
                  onPressed: () {
                    tempList.tempVariation.add(ProductVariation(
                        name: varLabel.text,
                        price: double.parse(varPrice.text)));
                    varLabel.text = "";
                    varPrice.text = "";
                    setState(() {
                      _listHeight = tempList.tempVariation.length * .17;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text("Add variation"),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _onSubmit() {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      DatabaseHelper().uploadProduct(_product, _image, context);
    } 
    else {
      return;
    }formState.reset();
  }

  Decoration boxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38.withOpacity(0.1),
            blurRadius: 0,
            spreadRadius: 1,
            offset: Offset(0, 0),
          )
        ]);
  }

  pickImageFromDevice() async{
       File temPImage =  await ImagePicker.pickImage(
                  source: ImageSource.gallery);
          decodeImage = await decodeImageFromList(
              temPImage.readAsBytesSync());
          _fileName = temPImage.path.split('/').last;
          setState(() {
            _image = temPImage;
            _filePath = temPImage.path;
            _product.image = temPImage.path;
          });
  }
}
