import 'dart:io';
import 'package:flutter/cupertino.dart';

class NotifyApp with ChangeNotifier{

  File _imageUpload;

  set tempImage(File file){
    _imageUpload = file;
  }
  get getImage{
    return _imageUpload;
  }

}