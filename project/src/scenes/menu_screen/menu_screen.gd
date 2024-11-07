extends Control

# Указываем путь к папке с изображениями
var folder_path_img = "res://assets/img"  

# Узел контейнера для изображений
onready var images_container = $MarginContainer/ScrollContainer/ImagesContainer  # указываем путь к GridContainer

func _on_DiscordButton_pressed():
	pass


func _on_WebsiteButton_pressed():
	pass

	
func _ready():
	
	var image_files = list_images_in_directory(folder_path_img)
		
	if image_files:
		for image_path in image_files:
			show_image(image_path)
	else:
		print(image_files)
		print("Папка пуста или путь указан неверно")

# Функция для получения списка изображений в указанной директории
func list_images_in_directory(path: String) -> Array:
	var dir = Directory.new()
	var images = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()  # Начинаем перебор содержимого папки
		
		var file_name = dir.get_next()  # Получаем первый файл
		while file_name != "":
			# без учета ".import" после экспорта у меня не работает ... 
			if !dir.current_is_dir() and (file_name.ends_with(".png.import") or file_name.ends_with(".jpg.import")):
				images.append(path + "/" + file_name.replacen(".import", ""))  # Сохраняем полный путь к файлу
			file_name = dir.get_next()  # Переходим к следующему элементу
		
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

		var texture_button = TextureButton.new()
		texture_button.texture_normal = resized_texture
		 # Настраиваем размер и свойства TextureButton
		texture_button.rect_min_size = Vector2(100, 100)  # Размер кнопки, меняйте по необходимости  
		 # Подключаем сигнал "pressed" к функции обработчика
		texture_button.connect("pressed", self, "_on_texture_button_pressed", [original_texture])
		
		images_container.add_child(texture_button)
	else:
		print("Не удалось загрузить изображение:", image_path)

# Функция-обработчик нажатия
func _on_texture_button_pressed(image: Texture):
	Global.image_texture = image
	var _error = get_tree().change_scene("res://src/scenes/game/game_scene.tscn")

