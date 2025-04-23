shader_type spatial;

uniform sampler2D mirror_texture;

render_mode unshaded;

void fragment() {
    COLOR = texture(mirror_texture, UV);
}
