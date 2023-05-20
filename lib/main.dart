import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

void main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Dicee'),
          backgroundColor: Colors.red,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> with TickerProviderStateMixin {
  final player = AudioPlayer();
  final player2 = AudioPlayer();
  late ConfettiController confettiController;

  late FlutterGifController controller;
  late FlutterGifController controller2;
  late FlutterGifController controllerClapp;
  int diceNumberFirst = Random().nextInt(6) + 1;
  int diceNumberSecond = Random().nextInt(6) + 1;

  @override
  void initState() {
    controller = FlutterGifController(vsync: this);
    controller2 = FlutterGifController(vsync: this);
    controllerClapp = FlutterGifController(vsync: this);
    confettiController = ConfettiController(duration: Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GifImage(
                      controller: controller,
                      image: AssetImage('images/dice$diceNumberFirst.gif'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GifImage(
                      controller: controller2,
                      image: AssetImage('images/dice$diceNumberSecond.gif'),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                player.play(AssetSource('diceroll.mp3'));
                setState(() {
                  diceNumberFirst = Random().nextInt(6) + 1;
                  diceNumberSecond = Random().nextInt(6) + 1;

                  controller2.animateBack(51,
                      duration: Duration(milliseconds: 1300));
                  controller.animateTo(51,
                      duration: Duration(milliseconds: 1500));

                  Future.delayed(Duration(milliseconds: 1500), () {
                    controller.reset();
                    controller2.reset();
                    if (diceNumberFirst == diceNumberSecond) {
                      confettiController.play();
                      controllerClapp.animateTo(29,
                          duration: Duration(milliseconds: 5000));
                      // controllerClapp.repeat(
                      //     min: 0,
                      //     max: 15,
                      //     period: const Duration(milliseconds: 500));
                      player2.play(AssetSource('match.mp3'));
                    } else {
                      confettiController.stop();
                      controllerClapp.reset();
                    }
                  });
                });
              },
              child: GifImage(
                controller: controllerClapp,
                image: AssetImage('images/win.gif'),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirection: pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            shouldLoop: false,
            displayTarget: true,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ),
      ],
    );
  }
}
