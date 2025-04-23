shader_type canvas_item;

uniform float speed = 5.0;
uniform float frequency_uniform = 30.0;

uniform bool is_breath = false;
uniform float breath_speed = 0.368;
uniform float breath_freq = 0.021;

void fragment() {
    float frequency = frequency_uniform;
    if (is_breath) {
        frequency = breath_freq * sin(TIME * breath_speed);
    }

    vec2 pos = UV * 2.0 - 1.0; // normalize UV to -1..1
    float oh_no = cos(pos.x * TIME * speed) + sin(pos.y * TIME * speed);
    float oh_god = sin(pos.y * TIME * speed) + cos(pos.x * TIME * speed);
    float oh_feck = sin(pos.y * TIME * speed) + cos(pos.x * TIME * speed);

    vec3 effect_color = vec3(
        sin(oh_no * frequency * TIME * speed),
        cos(oh_god * frequency * TIME * speed),
        tan(oh_feck * frequency * TIME * speed)
    );

    COLOR.rgb = effect_color;
    COLOR.a = COLOR.a; // keep alpha from modulate or texture
}
