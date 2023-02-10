import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shader_demo/shader_painter.dart';

class ShaderHomeImageBlur extends StatefulWidget {
  const ShaderHomeImageBlur({super.key});

  @override
  State<ShaderHomeImageBlur> createState() =>
      _ShaderHomeImageBlurState();
}

class _ShaderHomeImageBlurState extends State<ShaderHomeImageBlur> {
  late Timer timer;
  double delta = 0;
  FragmentShader? shader;
  ui.Image? image;

  void loadMyShader() async {
    final imageData = await rootBundle.load('assets/dash.jpg');
    image = await decodeImageFromList(imageData.buffer.asUint8List());

    var program =
        await FragmentProgram.fromAsset('shaders/shader_image_blur.frag');
    shader = program.fragmentShader();
    setState(() {
      // trigger a repaint
    });

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        delta += 1 / 60;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyShader();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
                painter: ShaderPainter(shader!, [delta], [image!])),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.chevron_left),
            ),
          ),
        ],
      );
    }
  }
}
