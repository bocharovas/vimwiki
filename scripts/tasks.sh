#!/bin/bash

VIMWIKI_FILE="$HOME/vimwiki/index.md"

sed -n '/due:[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/p' "$VIMWIKI_FILE" | while read -r line; do

  if echo "$line" | grep -q '\[x\]'; then
    echo "Пропускаю выполненную задачу: $line"
    continue
  fi

  task=$(echo "$line" | sed 's/([^)]*)//g; s/- \[//; s/\]//g')

  task_name=$(echo "$task" | awk '{print $1}')
  due=$(echo "$task" | grep -oP 'due:\S+')
  reminder=$(echo "$task" | grep -oP 'reminder:\S+')
  recurrence=$(echo "$task" | grep -oP 'recurrence:\S+')

  echo "Название задачи: $task_name"
  echo "Параметры: due=$due, reminder=$reminder, recurrence=$recurrence"

  command="task add \"$task_name\" $due $reminder $recurrence"
  echo "Добавляю задачу с командой: $command"

  if eval $command; then
    echo "✅ Задача успешно добавлена!"
  else
    echo "❌ Не удалось добавить задачу!"
  fi
done

