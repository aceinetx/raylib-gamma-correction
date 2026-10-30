Color :: struct {
	r: u8;
	g: u8;
	b: u8;
	a: u8;

	black :: () -> Color #expand {
		return .{0x00, 0x00, 0x00, 0xff};
	}

	white :: () -> Color #expand {
		return .{0xff, 0xff, 0xff, 0xff};
	}
}

Shader :: struct {
	id: u32;
	locs: *s32;

	load_from_memory :: (vsCode: *u8, fsCode: *u8) -> Shader #foreign raylib "LoadShaderFromMemory";
	unload :: (shader: Shader) #foreign raylib "UnloadShader";

	begin :: (shader: Shader) #foreign raylib "BeginShaderMode";
	end :: () #foreign raylib "EndShaderMode";

	get_location :: (shader: Shader, uniformName: *u8) -> s32 #foreign raylib "GetShaderLocation";

	UniformType :: struct {
		FLOAT     : s32 : 0;
		VEC2      : s32 : 1;
		VEC3      : s32 : 2;
		VEC4      : s32 : 3;
		INT       : s32 : 4;
		IVEC2     : s32 : 5;
		IVEC3     : s32 : 6;
		IVEC4     : s32 : 7;
		UINT      : s32 : 8;
		UIVEC2    : s32 : 9;
		UIVEC3    : s32 : 10;
		UIVEC4    : s32 : 11;
		SAMPLER2D : s32 : 12;
	}

	_set_value :: (shader: Shader, locIndex: s32, value: *void, uniformType: s32) #foreign raylib "SetShaderValue";
	_set_value_v :: (shader: Shader, locIndex: s32, value: *(), uniformType: s32) #foreign raylib "SetShaderValue";

	set_value :: (shader: Shader, locIndex: s32, value: float) {
		_set_value(shader, locIndex, *value, UniformType.FLOAT);
	}
}

Rectangle :: struct {
	x: float;
	y: float;
	width: float;
	height: float;
}

Vector2 :: struct {
	x: float;
	y: float;

	zero :: () -> Vector2 {
		return .{0, 0};
	}
}

Texture :: struct {
	id: u32;
	width: s32;
	height: s32;
	mipmaps: s32;
	format: s32;

	load_from_image :: (image: Image) -> Texture #foreign raylib "LoadTextureFromImage";
	load_from_image_memory :: (fileType: *u8, fileData: *u8, dataSize: s32) -> Texture {
		image := Image.load_from_memory(fileType, fileData, dataSize);
		if !image.data  return .{};

		return load_from_image(image);
	}
	unload :: (texture: Texture) #foreign raylib "UnloadTexture";

	draw :: (texture: Texture, posX: s32, posY: s32, tint: Color) #foreign raylib "DrawTexture";
	draw_rec :: (texture: Texture, rec: Rectangle, position: Vector2, tint: Color) #foreign raylib "DrawTextureRec";
}

RenderTexture :: struct {
	id: u32;
	texture: Texture;
	depth: Texture;

	load :: (x: s32, y: s32) -> RenderTexture #foreign raylib "LoadRenderTexture";
	unload :: (texture: RenderTexture) #foreign raylib "UnloadRenderTexture";

	begin :: (target: RenderTexture) #foreign raylib "BeginTextureMode";
	end :: () #foreign raylib "EndTextureMode";
}

Image :: struct {
	data: *();
	width: s32;
	height: s32;
	mipmaps: s32;
	format: s32;

	load_from_memory :: (fileType: *u8, fileData: *u8, dataSize: s32) -> Image #foreign raylib "LoadImageFromMemory";
	unload :: (image: Image) #foreign raylib "UnloadImage";
}

init_window :: (x: s32, y: s32, title: *u8) #foreign raylib "InitWindow";
close_window :: () #foreign raylib "CloseWindow";
window_should_close :: () -> bool #foreign raylib "WindowShouldClose";
begin_drawing :: () #foreign raylib "BeginDrawing";
end_drawing :: () #foreign raylib "EndDrawing";
clear_background :: (color: Color) #foreign raylib "ClearBackground";
draw_text :: (text: *u8, posX: s32, posY: s32, fontSize: s32, color: Color) #foreign raylib "DrawText";
text_format :: (text: *u8, args: ..Any) -> *u8 #foreign raylib "TextFormat" #c_call;
get_mouse_wheel_move :: () -> float #foreign raylib "GetMouseWheelMove";

#scope_file
raylib :: #library "raylib";

