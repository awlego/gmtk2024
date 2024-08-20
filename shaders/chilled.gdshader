shader_type canvas_item;

uniform bool enabled = true;
uniform vec4 outline_color : source_color = vec4(0.5, 0.8, 1.0, 1.0);
uniform float outline_thickness : hint_range(0, 10) = 1.0;
uniform float glow_strength : hint_range(0, 2) = 1.0;

void fragment() {
	if (enabled) {
		vec2 texture_pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
    	vec4 base_color = texture(TEXTURE, UV);
    
	    if (base_color.a == 0.0) {
	        vec4 outline = vec4(0.0);
	        for (float x = -outline_thickness; x <= outline_thickness; x++) {
	            for (float y = -outline_thickness; y <= outline_thickness; y++) {
	                if (length(vec2(x, y)) <= outline_thickness) {
	                    vec2 offset = vec2(x, y) * texture_pixel_size;
	                    vec4 sample_color = texture(TEXTURE, UV + offset);
	                    if (sample_color.a > 0.0) {
	                        outline = outline_color * glow_strength;
	                        outline.a = 1.0;
	                        break;
	                    }
	                }
	            }
	            if (outline.a > 0.0) break;
	        }
	        COLOR = outline;
	    } else {
	        COLOR = base_color;
	    }
	}
}