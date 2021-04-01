import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../models/blocks_model.dart';
import 'hex_color.dart';

class BannerTopSlider extends StatefulWidget {
  final Block block;
  final Function onBannerClick;
  BannerTopSlider({Key key, this.block, this.onBannerClick}) : super(key: key);
  @override
  _BannerTopSliderState createState() => _BannerTopSliderState();
}

class _BannerTopSliderState extends State<BannerTopSlider> {

  bool _isVisible = false;

  //*

  // */
  @override
  Widget build(BuildContext context) {
    Color bgColor = HexColor(widget.block.bgColor);
    return SliverToBoxAdapter(
        child: Stack(
          //overflow: Overflow.visible,
          children: [
            Container(
              height: 310,
              width: double.infinity,
              child: buildImagesSwiper(context),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: BackdropFilter(
                filter:  ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Stack(
                  children:  [
                    Container(
                      height: 300,
                      //color: Colors.red ,
                      width: double.infinity,
                      child: CustomPaint(
                          painter: CurvedPainter()
                      ),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Container(
                        //height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: topImageSwiper(context),
                      ),
                    ),
                  ],
                ),),
            ),
          ],
        ),
    );
  }

  Widget buildImagesSwiper(BuildContext context) {
    //TabController imagesController = TabController(length: 3, vsync: this );
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.block.children[index].image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  )
                ],
              );
            },
            itemCount:  widget.block.children.length,
            pagination: SwiperPagination(
              //margin: EdgeInsets.only(bottom:40),
              builder: new DotSwiperPaginationBuilder(
                  color: Color(0xffb0bec5),
                  activeColor: Colors.white,
                  size: 8,
                  activeSize: 10),
            ),
            //curve: Curves.easeOutCubic,
            autoplay: true,
            // containerHeight: 20,
            viewportFraction:1,
            scale: 1,
          ),
        ),

      ],
    );
  }

  Widget topImageSwiper(BuildContext context) {
    //TabController imagesController = TabController(length: 3, vsync: this );
    return Stack(
      children: <Widget>[
        Container(
          //alignment: Alignment.topCenter,
          width: double.infinity,
          height: 180,
          // color: Colors.red,

          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    splashColor: Theme.of(context).hintColor,
                    onTap: () => null,
                    child: Image.network(
                      widget.block.children[index].image,
                      fit: BoxFit.fill,

                    ));
              },
              itemCount:  widget.block.children.length,
              pagination: SwiperPagination(
                //margin: EdgeInsets.only(bottom:40),
                builder: new DotSwiperPaginationBuilder(
                    color: Color(0xffb0bec5),
                    activeColor: Colors.white,
                    size: 8,
                    activeSize: 10),
              ),
              //curve: Curves.easeOutCubic,
              autoplay: true,
              // containerHeight: 20,
              viewportFraction:1,
              scale: 0.9,
            ),
          ),
        ),

      ],
    );
  }
}

class CurvedPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {
  var paint = Paint();
  paint.color = Colors.white;
  paint.style = PaintingStyle.fill; // Change this to fill

  var path = Path();

  path.moveTo(0, size.height-200);
  path.quadraticBezierTo(size.width/2, size.height-120,
      size.width, size.height - 200);
  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);

  canvas.drawPath(path, paint);
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return true;
}
}
