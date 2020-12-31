shader_type canvas_item;

uniform sampler2D palette;

void fragment() {
	vec4 rgba = texture(TEXTURE, UV);
	vec4 final_color = texture(palette, vec2(rgba.r, rgba.g));
	final_color.a = rgba.a;
	
	COLOR = final_color;
}