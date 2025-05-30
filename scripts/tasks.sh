#!/bin/bash

# Укажите путь к вашему vimwiki
VIMWIKI_FILE="$HOME/vimwiki/index.md"

# Найдем все строки с задачами в формате: - название due: reminder:
sed -n '/due:[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/ { s/([^)]*)//g; s/- \[//; s/\]//g; p }' "$VIMWIKI_FILE" | while read -r task; do
  # Извлекаем название задачи и параметры
  task_name=$(echo "$task" | awk '{print $1}')
  due=$(echo "$task" | grep -oP 'due:\S+')
  reminder=$(echo "$task" | grep -oP 'reminder:\S+')
  recurrence=$(echo "$task" | grep -oP 'recurrence:\S+')

  # Выведем параметры для отладки
  echo "Название задачи: $task_name"
  echo "Параметры: due=$due, reminder=$reminder, recurrence=$recurrence"

  # Добавляем задачу в Taskwarrior
  command="task add \"$task_name\" $due $reminder $recurrence"
  echo "Добавляю задачу с командой: $command"

  # Проверим выполнение команды
  if eval $command; then
    echo "✅ Задача успешно добавлена!"
  else
    echo "❌ Не удалось добавить задачу!"
  fi
done
