import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:n2ma/ui/home.dart';
import 'package:n2ma/ui/userlocation.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:provider/provider.dart';

import 'ui/pickUpLocations.dart';
import 'ui/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
            
        ChangeNotifierProvider(create: (context) => VariationNotifier()),
        ChangeNotifierProvider(create: (context) => FavoriteNotifier(),)
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Poppins",
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
