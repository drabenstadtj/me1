shader_type canvas_item;

uniform float fade; // Lower = longer trails

void fragment() {
    vec4 current = texture(TEXTURE, UV);
    current.rgb *= fade;
    COLOR = current;
}
