import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:xlo/models/ad.dart';
import 'package:xlo/screens/product/widgets/description_panel.dart';
import 'package:xlo/screens/product/widgets/location_panel.dart';
import 'package:xlo/screens/product/widgets/main_panel.dart';
import 'package:xlo/screens/product/widgets/user_panel.dart';

import 'widgets/botton_bar.dart';

class ProductScreen extends StatelessWidget {
  final Ad ad;

  ProductScreen(this.ad);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anúncio"),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                height: 280,
                child: Carousel(
                  images: ad.images.map((e) => FileImage(e)).toList(),
                  dotSize: 4,
                  dotSpacing: 15,
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.pink,
                  autoplay: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MainPanel(
                      ad: ad,
                    ),
                    Divider(),
                    DescriptionPanel(
                      ad: ad,
                    ),
                    Divider(),
                    LocationPanel(ad: ad),
                    Divider(),
                    UserPanel(ad: ad),
                    Divider(),
                    Container(
                      height: 92,
                    )
                  ],
                ),
              )
            ],
          ),
          BottonBar(ad: ad),
        ],
      ),
    );
  }
}
