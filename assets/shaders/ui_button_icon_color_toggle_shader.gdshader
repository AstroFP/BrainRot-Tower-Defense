shader_type canvas_item;
render_mode blend_mix;

uniform vec3 color : source_color = vec3(0.0, 0.0, 0.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
	COLOR = vec4(color, tex_color.a) * vec4(1.0, 1.0, 1.0, COLOR.a);
}

