shader_type spatial;
render_mode depth_test_disabled, unshaded, cull_disabled;

uniform vec4 dot_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_thickness : hint_range(0.001, 0.1) = 0.02;
uniform float dot_spacing : hint_range(0.02, 1.0) = 0.15;
uniform float dot_duty : hint_range(0.02, 1.0) = 0.25;
uniform float speed : hint_range(0.0, 10.0) = 1.0;

// --- Helpers ---
float aastep(float threshold, float value) {
    float afwidth = fwidth(value) * 0.7071;
    return smoothstep(threshold - afwidth, threshold + afwidth, value);
}

void fragment() {
    vec2 uv = UV;

    // Distance to edges
    float d_bottom = uv.y;
    float d_top    = 1.0 - uv.y;
    float d_left   = uv.x;
    float d_right  = 1.0 - uv.x;

    // Closest edge distance
    float edge_dist = min(min(d_bottom, d_top), min(d_left, d_right));

    // Border mask
    float in_border = 1.0 - aastep(border_thickness, edge_dist);
    if (in_border <= 0.0) {
        ALPHA = 0.0;
    }else{
	    // Pick the closest edge (no weighted blending → no diagonal line)
	    float t = 0.0;
	    if (edge_dist == d_bottom) {
	        t = uv.x;                 // bottom: left→right
	    } else if (edge_dist == d_right) {
	        t = 1.0 + uv.y;           // right: bottom→top
	    } else if (edge_dist == d_top) {
	        t = 2.0 + (1.0 - uv.x);   // top: right→left
	    } else { // d_left
	        t = 3.0 + (1.0 - uv.y);   // left: top→bottom
	    }

	    // Animate clockwise
	    float s = (t - TIME * speed) / max(dot_spacing, 1e-4);
	    float frac = fract(s);

	    // Dot duty cycle
	    float dot_on = 1.0 - aastep(clamp(dot_duty, 0.02, 1.0), frac);

	    // Apply mask
	    float mask = in_border * dot_on;

	    ALBEDO = dot_color.rgb;
	    ALPHA = dot_color.a * mask;

	}

}
