import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import './../../../models/product_model.dart';

class GalleryView extends StatefulWidget {
  final List<Mage> images;

  const GalleryView({Key key, this.images}) : super(key: key);
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget.images[index].src),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      //heroAttributes: HeroAttributes(tag: images[index].id),
                    );
                  },
                  itemCount: widget.images.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                      ),
                    ),
                  ),
                  //backgroundDecoration: widget.backgroundDecoration,
                  //pageController: widget.pageController,
                  //onPageChanged: onPageChanged,
                )
            ),
            Positioned(
                top: 32,
                left: 16,
                child: IconButton(
                    icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        width: 35,
                        height: 35,
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 18,)
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    })),
          ],
        ),
      ),
    );
  }
}
