import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShaderHomeFractalPyramid extends StatefulWidget {
  const ShaderHomeFractalPyramid({super.key});

  @override
  State<ShaderHomeFractalPyramid> createState() =>
      _ShaderHomeFractalPyramidState();
}

class _ShaderHomeFractalPyramidState extends State<ShaderHomeFractalPyramid> {
  late Timer timer;
  double delta = 0;
  FragmentShader? shader;
  ui.Image? image;

  void loadMyShader() async {
    final imageData = await rootBundle.load('assets/dash.jpg');
    image = await decodeImageFromList(imageData.buffer.asUint8List());

    var program =
        await FragmentProgram.fromAsset('shaders/shader_fractal_pyramid.frag');
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
                painter: FractalPyramidPainter(shader!, delta, image!)),
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

class FractalPyramidPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final ui.Image? image;

  FractalPyramidPainter(FragmentShader fragmentShader, this.time, this.image)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setImageSampler(0, image!);
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    final paint = Paint();

    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
