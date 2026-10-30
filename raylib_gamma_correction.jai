#import "raylib";
#import "Basic";
#import "File";

SCREEN_WIDTH  : s32 = 1366;
SCREEN_HEIGHT : s32 = 768;

SHADER :: #string DONE
#version 330

in vec2 fragTexCoord;
out vec4 fragColor;
uniform sampler2D texture0;
uniform float y = 1;
uniform float A = 1;

void main() {
	vec4 col = texture(texture0, fragTexCoord);

	vec3 rgb = A * pow(max(col.rgb, vec3(0.0)), vec3(y));
	fragColor = vec4(rgb, col.a);
}
DONE;

PICTURE :: #run -> string {
	content, success := read_entire_file("pic.png");
	assert(success);
	return content;
}

main :: () {
	init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "gamma correction");
	defer close_window();

	render_texture := RenderTexture.load(SCREEN_WIDTH, SCREEN_HEIGHT);
	defer RenderTexture.unload(render_texture);

	shader := Shader.load_from_memory(null, SHADER);
	defer Shader.unload(shader);

	y_loc := Shader.get_location(shader, "y");
	y : float = 1.0;

	picture := Texture.load_from_image_memory(".png", PICTURE.data, PICTURE.count);
	defer Texture.unload(picture);

	while !window_should_close() {
		begin_drawing();
		defer end_drawing();

		// main drawing
		RenderTexture.begin(render_texture);
		clear_background(Color.black());
		Texture.draw(picture, 0, 0, Color.white());
		draw_text(text_format("y: %f", y), 0, 0, 18, Color.white());
		RenderTexture.end();

		// setup shader uniforms
		Shader.set_value(shader, y_loc, y);

		// apply shader
		Shader.begin(shader);
		Texture.draw_rec(
			render_texture.texture,
			Rectangle.{0, 0, xx render_texture.texture.width, xx -render_texture.texture.height},
			Vector2.zero(),
			Color.white(),
		);
		Shader.end();

		// input
		y += get_mouse_wheel_move() / 50;
	}
}
