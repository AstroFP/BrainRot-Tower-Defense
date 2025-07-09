shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color_top : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_bottom : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    float factor = UV.y;
    COLOR = mix(color_top, color_bottom, factor) * vec4(1.0, 1.0, 1.0, COLOR.a);
}
