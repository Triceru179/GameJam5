shader_type canvas_item;

uniform sampler2D palette;

uniform int palette_count = 1;
uniform int initial_hue_index = 7;
uniform int final_hue_index = 0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float a = step(0.00392, color.a);
	
	for (int i = 0; i < palette_count; i++)
	{
		vec4 pixel = texelFetch(palette, ivec2(i, initial_hue_index), 0);
		
		vec4 new_color = texelFetch(palette, ivec2(i, final_hue_index), 0);
		new_color.a *= a;
		COLOR = new_color;
	}
}

//Or more generally for pixel i in a N wide texture the proper texture coordinate is

//(2i + 1)/(2N)