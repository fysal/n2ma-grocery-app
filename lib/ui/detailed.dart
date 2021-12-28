import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/modals/itemModal.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:n2ma/tools/customIcons.dart';


class DetailScreen extends StatefulWidget {
  GroceryItem item;
  int index;
  int id;

  DetailScreen(this.item, this.index);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String userImage;
  var _controller = TextEditingController();
  int qty = 1;
  var amount;
  GroceryItem groceryItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = qty.toString();
    amount = widget.item.price * qty;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    groceryItem = widget.item;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: green,
          ),
       Positioned(
         top: 0,
         left: 0,
         width: screenSize.width,
         height: screenSize.height,
         child: Stack(
           children: <Widget>[
             Hero(
               tag: widget.index,
               child: ClipPath(
                 clipper: SwallShape(),
                 child: Container(
                   width: screenSize.width,
                   height: screenSize.height - screenSize.width / 2.2,
                   color: groceryItem.color,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Container(
                         alignment: Alignment.center,
                           width: screenSize.width ,
                           height: screenSize.height / 2,
                           decoration: BoxDecoration(
                               image: DecorationImage(
                                   fit: BoxFit.contain,
                                   image: AssetImage(widget.item.image)))
                       ),
                       Container(
                         padding: EdgeInsets.only(top:0,left: 20, right:20),
                         width: screenSize.width,
                         child: Material(
                           color: Colors.transparent,
                           child: Text(
                             widget.item.name.toString(),
                             style: nameStyleDetail.copyWith(
                                 fontSize: ScreenUtil().setSp(110),
                                 height: 1,

                                 color: Colors.black.withOpacity(.5)),
                           ),
                         ),
                       ),

                     ],
                   ),
                 ),
               ),
             ),
             Positioned(
               bottom: 0,
               left: 0,
               child: Container(
                 padding: EdgeInsets.all(20),
                 width: screenSize.width,
                 height: screenSize.height / 2.8,
                // color: Colors.red,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Material(
                       elevation: 10,
                     borderRadius: BorderRadius.circular(50),
                       child: Container(
                         padding: EdgeInsets.symmetric(horizontal: 15),

                         decoration: BoxDecoration(
                           color: green,
                           borderRadius: BorderRadius.circular(50)
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             GestureDetector(
                               onTap: () {
                                 addQty();
                               },
                               child: Container(
                                 height: 40,
                                 width: 40,
                                 decoration: BoxDecoration(
                                   boxShadow: [
                                     BoxShadow(
                                         color: Colors.black.withOpacity(.1),
                                         offset: Offset(0, 0),
                                         spreadRadius: 3,
                                         blurRadius: 5)
                                   ],
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(50),
                                 ),
                                 child: Icon(
                                   Icons.add,color: Colors.black.withOpacity(.5),
                                   size: ScreenUtil().setWidth(80),
                                 ),
                               ),
                             ),
                             SizedBox(
                               height: 10,
                             ),
                             Container(
                               height: 50,
                               width: 50,
                               decoration: BoxDecoration(
                                 boxShadow: [
                                   BoxShadow(
                                     color: Colors.black.withOpacity(.1),
                                     offset: Offset(0.5, 0.5),
                                   ),
                                 ],
                                 color: softWhite,
                                 borderRadius: BorderRadius.circular(60),
                               ),
                               child: Padding(
                                 padding: EdgeInsets.only(bottom: 5),
                                 child: TextField(
                                   textAlign: TextAlign.center,
                                   controller: _controller,
                                   enabled: false,
                                   style: TextStyle(
                                       fontFamily: "Poppins",
                                       fontSize: ScreenUtil().setSp(60),
                                       color: Colors.black.withOpacity(.6),
                                       fontWeight: FontWeight.bold),
                                   decoration: InputDecoration(border: InputBorder.none),
                                 ),
                               ),
                             ),
                             SizedBox(
                               height: 10,
                             ),
                             GestureDetector(
                               onTap: () {
                                 reduceQty();
                               },
                               child: Container(
                                 height: 40,
                                 width: 40,
                                 decoration: BoxDecoration(
                                   boxShadow: [
                                     BoxShadow(
                                         color: Colors.black.withOpacity(.1),
                                         offset: Offset(0, 0),
                                         spreadRadius: 3,
                                         blurRadius: 5)
                                   ],
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(50),
                                 ),
                                 child: Icon(
                                   Icons.remove, color: Colors.black.withOpacity(.5),
                                   size: ScreenUtil().setWidth(80),
                                 ),
                               ),
                             ),

                           ],
                         ),
                       ),
                     ),
                     Material(
                       color: Colors.white,
                       elevation: 10,
                         borderRadius: BorderRadius.circular(50),
                       child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                         child: Column(
                           children: <Widget>[
                             Expanded(
                               child: Container(),
                             ),
                             Container(
                               height: 60,
                               width: 60,
                               decoration: BoxDecoration(
                                 boxShadow: [
                                   BoxShadow(
                                       color: Colors.black.withOpacity(.1),
                                       offset: Offset(0, 0),
                                       spreadRadius: 3,
                                       blurRadius: 5)
                                 ],
                                 color: green,
                                 borderRadius: BorderRadius.circular(50),
                               ),
                               child: Icon(
                                 CustomIcons.basket,
                                 size: ScreenUtil().setWidth(80),
                                 color: gray,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
//                     Container(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "Add to cart",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: ScreenUtil().setSp(40),
//                             height: 1,
//                           ),
//                           textAlign: TextAlign.center,
//                         ))
                   ],
                 ),
               ),
             )
           ]
         ),
       ),
          Positioned(
            top: 30,
            child: Container(
              width: screenSize.width,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.white,),),

                  ClipOval(
                    child: Container(
                      width: 50,height: 50,
                      decoration: BoxDecoration(
                        color: green,

                      ),
                    ),
                  )
                ],

              ),
            ),
          ),

        ],
      )
    );
  }

  addQty() {
    qty++;
    setState(() {
      _controller.text = qty.toString();
      amount = widget.item.price * qty;
    });
  }

  reduceQty() {
    if (qty > 1) {
      qty--;
      setState(() {
        _controller.text = qty.toString();
        amount = amount - widget.item.price;
      });
    } else {
      qty = 1;
      setState(() {
        _controller.text = qty.toString();
      });
    }
  }
}


class SwallShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(0, size.height - 25, 20, size.height - 43);
    path.quadraticBezierTo(35, size.height - 56, 60, size.height- 58);
    path.lineTo(size.width - 80, size.height - 60);
    path.quadraticBezierTo(size.width - 5, size.height - 55, size.width, size.height - 120);
    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}