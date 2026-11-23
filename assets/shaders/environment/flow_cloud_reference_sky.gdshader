// Godot equivalent of the reference project's screen-space gradient sky.
shader_type sky;

uniform vec3 bottom_color : source_color = vec3(0.81060874, 0.78195083, 0.8679245);
uniform vec3 top_color : source_color = vec3(0.9811321, 0.98112935, 0.85617656);

void sky() {
	float gradient = clamp(EYEDIR.y * 0.5 + 0.5, 0.0, 1.0);
	COLOR = mix(bottom_color, top_color, gradient);
}

