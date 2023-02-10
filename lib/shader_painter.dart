import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final List<double> uniforms;
  final List<ui.Image?> images;

  ShaderPainter(FragmentShader fragmentShader, this.uniforms, this.images)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < images.length; i++) {
      shader.setImageSampler(i, images[i]!);
    }
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    for(var i = 0; i < uniforms.length; i++) {
      shader.setFloat(i + 2, uniforms[i]);
    }

    final paint = Paint();

    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
