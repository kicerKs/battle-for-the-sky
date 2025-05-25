extends AnimatedSprite2D

func setup_animations(sprite_sheet: Texture2D) -> void:
	# Clear any existing animations
	var sprite_frames = SpriteFrames.new()
	self.sprite_frames = sprite_frames
	
	# Sprite sheet layout parameters
	var columns = 7
	var rows = 4
	var frame_size = Vector2(sprite_sheet.get_width() / columns, sprite_sheet.get_height() / rows)
	
	# Create each animation
	create_idle_animation(sprite_sheet, frame_size)
	create_walk_animation(sprite_sheet, frame_size)
	create_attack_animation(sprite_sheet, frame_size)
	create_death_animation(sprite_sheet, frame_size)

func create_idle_animation(sprite_sheet: Texture2D, frame_size: Vector2) -> void:
	var atlas = AtlasTexture.new()
	atlas.atlas = sprite_sheet
	atlas.region = Rect2(0, 0, frame_size.x, frame_size.y)
	
	sprite_frames.add_animation("idle")
	sprite_frames.add_frame("idle", atlas)
	sprite_frames.set_animation_speed("idle", 1)

func create_walk_animation(sprite_sheet: Texture2D, frame_size: Vector2) -> void:
	sprite_frames.add_animation("walk")
	
	var row = 1  # Second row
	for column in range(7):  # All 7 columns
		var atlas = AtlasTexture.new()
		atlas.atlas = sprite_sheet
		atlas.region = Rect2(column * frame_size.x, row * frame_size.y, frame_size.x, frame_size.y)
		
		sprite_frames.add_frame("walk", atlas)
	
	sprite_frames.set_animation_speed("walk", 10)
	sprite_frames.set_animation_loop("walk", true)

func create_attack_animation(sprite_sheet: Texture2D, frame_size: Vector2) -> void:
	sprite_frames.add_animation("attack")
	
	var row = 2  # Third row
	for column in range(7):  # All 7 columns
		var atlas = AtlasTexture.new()
		atlas.atlas = sprite_sheet
		atlas.region = Rect2(column * frame_size.x, row * frame_size.y, frame_size.x, frame_size.y)
		
		sprite_frames.add_frame("attack", atlas)
	
	sprite_frames.set_animation_speed("attack", 15)
	sprite_frames.set_animation_loop("attack", true)

func create_death_animation(sprite_sheet: Texture2D, frame_size: Vector2) -> void:
	sprite_frames.add_animation("death")
	
	var row = 3  # Fourth row
	for column in range(4):  # First 4 columns
		var atlas = AtlasTexture.new()
		atlas.atlas = sprite_sheet
		atlas.region = Rect2(column * frame_size.x, row * frame_size.y, frame_size.x, frame_size.y)
		
		sprite_frames.add_frame("death", atlas)
	
	sprite_frames.set_animation_speed("death", 8)
	sprite_frames.set_animation_loop("death", false)
