shader_type canvas_item;

uniform float flicker_speed = 10.0;
uniform float flicker_amount = 0.5;
uniform bool flicker_enabled = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (tex_color.a > 0.0 && flicker_enabled) { // Check if alpha channel is non-zero and flicker is enabled
        float flicker = sin(TIME * flicker_speed) * flicker_amount;
        COLOR = vec4(tex_color.rgb * (1.0 + flicker), tex_color.a);
    } else {
        COLOR = tex_color; // No flicker effect for transparent pixels or when flicker is disabled
    }
}