import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carouselimages extends StatefulWidget {
  final List<String> images;
  const Carouselimages({super.key, required this.images});

  @override
  State<Carouselimages> createState() => _CarouselimagesState();
}

class _CarouselimagesState extends State<Carouselimages> {
  int _currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          CarouselSlider(
            items: widget.images.map((link) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  child: Image.network(link));
            }).toList(),
            options: CarouselOptions(
              height: 200,
              enableInfiniteScroll: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) => {
                setState(() {
                  _currentindex = index;
                })
              },
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((e) {
                return Container(
                  width: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(_currentindex == e.key ? 0.9 : 0.4)),
                );
              }).toList()),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ]);
  }
}
