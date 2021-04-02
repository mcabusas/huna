import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String url;
  final double radius;
  final double width;
  final double height; 
  ProfilePicture({@required this.url, this.height, this.width, this.radius});
  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
    // return CircleAvatar(
    //   radius: radius,
    //   child: Image.network(url, 
    //   fit: BoxFit.fill),
    // );
  }
}
