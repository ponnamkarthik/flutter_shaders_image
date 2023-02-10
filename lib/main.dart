import 'package:flutter/material.dart';
import 'package:shader_demo/fractal_pyramid/shader_home_fractal_pyramid.dart';
import 'package:shader_demo/pixelation/shader_home_pixelation.dart';
import 'package:shader_demo/shader_image_blur/shader_home_image_blur.dart';
import 'package:shader_demo/shader_image_blur/shader_home_image_curl_noise.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shader Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shader Demo'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShaderHomePixelationPage(),
                ),
              );
            },
            child: const Text('Pixelation'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShaderHomeFractalPyramid(),
                ),
              );
            },
            child: const Text('Fractal Pyramid'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShaderHomeImageBlur(),
                ),
              );
            },
            child: const Text('Image Manipulation'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShaderHomeImageCurlNoise(),
                ),
              );
            },
            child: const Text('Image Curl Noise'),
          ),

        ]
      ),
    );
  }
}
