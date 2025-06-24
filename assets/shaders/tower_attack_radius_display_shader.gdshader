shader_type canvas_item;

uniform vec4 fill_color : source_color;   // Color inside the circle (with alpha)
uniform vec4 border_color : source_color; // Color of the border (with alpha)
uniform float border_thickness = 0.05;  // Thickness of border (0.0 to 1.0 range)

void fragment() {
    // Normalize UV to -1 to 1 range
    vec2 uv = (UV - vec2(0.5)) * 2.0;
    float dist = length(uv);

    // Define circle radius
    float radius = 1.0;

    // Smooth edges
    float edge_smooth = 0.005;

    // Inner and outer thresholds
    float inner = radius - border_thickness;

    // Blend between fill and border based on distance
    if (dist > radius) {
        discard; // Fully outside the circle
    } else if (dist > inner) {
        // Border area
        COLOR = border_color;
    } else {
        // Inside fill area
        COLOR = fill_color;
    }

    // Optional: Add a smooth edge to avoid aliasing
    float alpha_fade = smoothstep(radius, radius - edge_smooth, dist);
    COLOR.a *= alpha_fade;
}
