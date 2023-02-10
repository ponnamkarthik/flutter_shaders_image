import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShaderHomePixelationPage extends StatefulWidget {
  const ShaderHomePixelationPage({super.key});

  @override
  State<ShaderHomePixelationPage> createState() =>
      _ShaderHomePixelationPageState();
}

class _ShaderHomePixelationPageState extends State<ShaderHomePixelationPage> {
  late Timer timer;
  double pixelSize = 0;
  double increment = 1;
  FragmentShader? shader;
  ui.Image? image;

  void loadMyShader() async {
    final imageData = await rootBundle.load('assets/dash.jpg');
    image = await decodeImageFromList(imageData.buffer.asUint8List());

    var program = await FragmentProgram.fromAsset('shaders/shader_pixel.frag');
    shader = program.fragmentShader();
    setState(() {
      // trigger a repaint
    });

    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        pixelSize += increment;
        if (pixelSize == 24 || pixelSize == 0) {
          increment *= -1;
          pixelSize += increment;
        }
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
                painter: PixelationShaderPainter(shader!, pixelSize, image!)),
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

class PixelationShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double pixelSize;
  final ui.Image? image;

  PixelationShaderPainter(
      FragmentShader fragmentShader, this.pixelSize, this.image)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setImageSampler(0, image!);
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, pixelSize);

    final paint = Paint();

    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
