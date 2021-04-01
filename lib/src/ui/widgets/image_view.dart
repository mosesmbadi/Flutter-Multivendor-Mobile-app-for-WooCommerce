import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final String url;
  const ImageView({Key key, this.url}) : super(key: key);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
                child: PhotoView(
              imageProvider: NetworkImage(widget.url),
            )),
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

class PhotoGalleryView extends StatefulWidget {
  final List<String> images;

  const PhotoGalleryView({Key key, this.images}) : super(key: key);
  @override
  _PhotoGalleryViewState createState() => _PhotoGalleryViewState();
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {

  PhotoViewController controller;
  double scaleCopy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.images[index]),
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                    //heroAttributes: HeroAttributes(tag: widget.posts[index].id),
                  );
                },
                itemCount: widget.images.length,
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
    );
  }
}


