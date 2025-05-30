#!/bin/bash

# Проверяем, что мы находимся внутри директории vimwiki
if [ ! -d "." ]; then
  echo "Вы не находитесь в директории vimwiki!"
  exit 1
fi

# Путь к файлу index.md в директории vimwiki
index_file="index.md"

# Создаем или очищаем файл index.md
echo "# Ссылки на файлы в vimwiki" > "$index_file"
echo "" >> "$index_file"

# Получаем список всех папок в директории vimwiki, исключая скрытые и папку diary
folders=$(find . -mindepth 1 -maxdepth 1 -type d ! -name "diary" ! -name ".*" )

# Добавляем все папки, кроме diary
for folder in $folders; do
  if [ -d "$folder" ]; then
    # Заголовок для текущей папки в index.md
    echo "## $(basename "$folder")" >> "$index_file"
    
    # Перебираем все файлы в папке и добавляем ссылки в index.md
    file_found=false
    for file in "$folder"/*; do
      if [ -f "$file" ]; then
        # Добавляем ссылку на файл в index.md
        echo "- [$(basename "$file")](./$(basename "$folder")/$(basename "$file"))" >> "$index_file"
        file_found=true
      fi
    done

    # Если в папке нет файлов, добавляем сообщение в index.md
    if [ "$file_found" = false ]; then
      echo "  - Нет файлов в этой папке." >> "$index_file"
    fi
    echo "" >> "$index_file"
  fi
done

# Проверяем, есть ли папка diary, и добавляем её в конец
if [ -d "diary" ]; then
  echo "## diary" >> "$index_file"
  for file in diary/*; do
    if [ -f "$file" ]; then
      echo "- [$(basename "$file")](./diary/$(basename "$file"))" >> "$index_file"
    fi
  done
fi

echo "index.md обновлен."
