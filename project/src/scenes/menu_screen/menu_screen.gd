extends Control

# Указываем путь к папке с изображениями
var folder_path = "res://img"  # замените "your_folder" на нужный путь

# Узел контейнера для изображений
onready var images_container = $ScrollContainer/ImagesContainer  # указываем путь к GridContainer

#func _ready():
#	$AnimationPlayer.play("menu_in")

func _on_DiscordButton_pressed():
	var _error = OS.shell_open("https://discord.gg/FZY9TqW")


func _on_WebsiteButton_pressed():
	var _error = OS.shell_open("https://delano-lourenco.web.app")


func _on_Button_pressed():
	var _error = get_tree().change_scene("res://src/scenes/game/game_scene.tscn")

func _ready():
	var image_files = list_images_in_directory(folder_path)
	
	if image_files:
		for image_path in image_files:
			show_image(image_path)
	else:
		print("Папка пуста или путь указан неверно")

# Функция для получения списка изображений в указанной директории
func list_images_in_directory(path: String) -> Array:
	var dir = Directory.new()
	var images = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and (file_name.ends_with(".png") or file_name.ends_with(".jpg")):
				images.append(path + "/" + file_name)  # Сохраняем полный путь к файлу
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print("Не удалось открыть папку:", path)
	
	return images

# Функция для отображения изображения
func show_image(image_path: String):
	var original_texture = load(image_path) as Texture
	if original_texture:
		var img = original_texture.get_data()  # Получаем данные изображения
		img.resize(100, 100)  # Изменяем размер изображения до 100x100
		var resized_texture = ImageTexture.new()
		resized_texture.create_from_image(img)  # Создаём новую текстуру из изменённого изображения
		
		var texture_rect = TextureRect.new()
		texture_rect.texture = resized_texture
		texture_rect.rect_min_size = Vector2(100, 100)  # Устанавливаем размер рамки 100x100

		images_container.add_child(texture_rect)
	else:
		print("Не удалось загрузить изображение:", image_path)
