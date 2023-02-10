#include <flutter/runtime_effect.glsl>

out vec4 fragColor;
uniform vec2 uSize;
uniform float pixelSize;
uniform sampler2D image;

vec4 pixel(vec2 pos, vec2 res) {
    pos = floor(pos * res) / res;
    if (max(abs(pos.x - 0.5), abs(pos.y - 0.5)) > 0.5) {
        return vec4(0.0);
    }
    return texture(image, pos.xy).rgba;
}

void main() {
    vec2 resolution = uSize;
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = FlutterFragCoord().xy / uSize;
    fragColor = pixel(uv, resolution.xy / pixelSize);
}