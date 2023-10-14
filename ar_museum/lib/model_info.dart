import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ModelInfo extends StatefulWidget {
  String modelName = "Мамонт";
  String desription;
  String audioPath;
  List<String> images;

  ModelInfo({super.key, required this.images, required this.desription, required this.audioPath});

  @override
  State<ModelInfo> createState() => _ModelInfoState();
}

class _ModelInfoState extends State<ModelInfo> {

  bool _expanded = false;
  bool _audioPlaying = false;
  int _activeIndex = 0;
  AudioPlayer? audioPlayer;

  void _handleExpand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  Widget _buildContent() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: widget.images.length,
            itemBuilder: (context, index, realIndex) {
              String path = widget.images[index];
              return _buildImage(path);
            },
            options: CarouselOptions(
                height: 200,
                viewportFraction: 1,
                onPageChanged: (index, reason) =>
                    setState(() => _activeIndex = index)
            ),
          ),
          const SizedBox(height: 32),
          _buildIndicator(),
          Expanded(
            child: _buildModelDescription()
          )
        ],
      )
    );
  }

  Widget _buildModelDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: const BoxDecoration(
        color: Color(0x00ffffff),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(76, 73, 73, 73),
            blurStyle: BlurStyle.inner,
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0),
          )
        ]
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child:  IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () async {
              if(_audioPlaying) {
                audioPlayer!.pause();
              } else {
                await audioPlayer!.play(DeviceFileSource(widget.audioPath));
              }
            },
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SingleChildScrollView(
                child: Text(
                  widget.desription,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              )
          ),
        ],
      )
    );
  }

  Widget _buildIndicator() => AnimatedSmoothIndicator(
      activeIndex: _activeIndex, count: widget.images.length,
      effect: const WormEffect(
        activeDotColor: Colors.white,
        dotColor: Color(0xFFB3B3B3)
      ));


  Widget _buildImage(String path) => Container(
    margin: EdgeInsets.symmetric(horizontal: 12),
    color: Colors.grey,
    child: Image.file(
      File(path),
      fit: BoxFit.cover,
    ),
  );

  @override
  Widget build(BuildContext context) {
    audioPlayer = AudioPlayer();
    audioPlayer!.onPlayerStateChanged.listen((event) {
      _audioPlaying = event == PlayerState.playing;
    });
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF49945),
            Color(0xFFFD1919),
          ]
        )
        ),
        child: SizedBox(
          width: double.infinity,
          height: _expanded ? MediaQuery.of(context).size.height - 100 : 100,
          child: Column(
            children: [
              TextButton(
                child: Text(widget.modelName,
                  style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: (){
                  _handleExpand();
                },
              ),
              _expanded ? Expanded(child: _buildContent()) : Container()
            ],
          )

        ),
      )
    );
  }

}