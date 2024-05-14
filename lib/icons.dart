import 'package:flutter/material.dart';

class CardBackAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('assets/card_back.png');
    Image image = Image(image: assetImage, width:57.1, height:88.9);
    return Container(child:image,);
  }

}