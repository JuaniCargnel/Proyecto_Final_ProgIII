shader_type canvas_item;

varying vec4 v_vertex_color;
uniform float flicker_speed = 10.0;
uniform float flicker_amount = 0.5;
uniform bool flicker_enabled = false;

void vertex() {
	v_vertex_color = COLOR;
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	if (tex_color.a > 0.0 && flicker_enabled) {
		float flicker = sin(TIME * flicker_speed) * flicker_amount;
		COLOR = vec4((v_vertex_color.rgb * tex_color.rgb) * (1.0 + flicker), tex_color.a);
	} else {
		COLOR = tex_color * v_vertex_color;
	}
}
