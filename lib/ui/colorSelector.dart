import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/tools/customColors.dart';
class ColorSelectr extends StatefulWidget {
  Color _defaultColor;
  File _image;

  ColorSelectr(this._defaultColor, this._image);

  @override
  _ColorSelectrState createState() => _ColorSelectrState();
}

class _ColorSelectrState extends State<ColorSelectr> {
  Color initialColor;
@override
  void initState() {
  initialColor = widget._defaultColor;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: initialColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:   <Widget>[
          SizedBox(height: 40,),
          IconButton(
            onPressed: () => Navigator.pop(context, initialColor),
            icon: Icon(Icons.close, size: ScreenUtil().setSp(80),color: Colors.white,),
          ),
          widget._image == null ? Container() : Image.file(widget._image),
          Expanded(
            child: Center(
              child: CircleColorPicker(
                initialColor: initialColor,
                onChanged: (color) {
                  setState(() {
                    initialColor = color;
                  });
                },
                size: const Size(240, 240),
                strokeWidth: 4,
                thumbSize: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
