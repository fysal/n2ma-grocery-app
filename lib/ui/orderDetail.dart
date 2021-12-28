import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/modals/order.dart';
import 'package:n2ma/styles/customStyles.dart';

class OrderDetail extends StatelessWidget{
  Order order;
  OrderDetail({this.order});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ScreenUtil.init(context, allowFontScaling: true );
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.width * 0.1,),
          Row(children: <Widget>[IconButton(icon: Icon(Icons.close,size: ScreenUtil().setWidth(90),),onPressed: ()=> Navigator.pop(context),),
          SizedBox(width: screenSize.width * 0.05,),
          Text("Order Details",style: nameStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(70),))],),
          SizedBox(height: screenSize.width * 0.05),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Text(order.orderId),
              ),
            ),
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: ()=>null,
            child: Container(width: screenSize.width,alignment: Alignment.center, color: Colors.amberAccent,child: Text("Re-order"),
            padding: const EdgeInsets.all(12),),
          ),
          SizedBox(height: screenSize.width * 0.05,)
        ],
      ),
    );
    throw UnimplementedError();
  }

}