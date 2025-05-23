#!/usr/bin/env bash

# Строгий режим: выход при ошибке, ошибка при использовании неустановленной переменной,
# и код выхода конвейера - это код последней команды, завершившейся с ошибкой.
set -euo pipefail

# --- Конфигурация по умолчанию ---
DEFAULT_LATEX_COMPILER="xelatex"
MAIN_FILE_BASENAME=""
QUIET_MODE=false
CLEAN_AFTER_BUILD=false
CLEAN_ONLY_MODE=false

# --- Функции ---

# Показать справку по использованию скрипта
usage() {
    cat <<EOF
Использование: $(basename "$0") [ОПЦИИ] <имя_основного_файла>

Собирает LaTeX-документ с использованием указанного компилятора LaTeX и Biber.
<имя_основного_файла> - это имя основного .tex файла без расширения .tex.

Аргументы:
  <имя_основного_файла>  Базовое имя основного .tex файла (например, 'mydocument' для 'mydocument.tex').
                          Обязателен для компиляции и для опции --clean-only.

Опции:
  -l, --latex-compiler <компилятор>
                          Указать компилятор LaTeX.
                          По умолчанию: "${DEFAULT_LATEX_COMPILER}". Примеры: pdflatex, lualatex, xelatex.
  -q, --quiet             Тихий режим (меньше вывода от LaTeX/Biber).
  --clean-after           Очистить вспомогательные файлы после успешной сборки.
  -C, --clean-only        Только очистить вспомогательные файлы для указанного <имя_основного_файла>.
                          Компиляция не производится.
  -h, --help              Показать это справочное сообщение и выйти.
EOF
    exit 0
}

# Очистка вспомогательных файлов LaTeX и Biber
clean_files() {
    local base_filename="$1"
    echo "🧹 Очистка вспомогательных файлов для ${base_filename}..."
    # Файлы, которые можно безопасно удалить:
    rm -f \
      "${base_filename}.aux" \
      "${base_filename}.bbl" \
      "${base_filename}.bcf" \
      "${base_filename}.blg" \
      "${base_filename}.log" \
      "${base_filename}.lof" \
      "${base_filename}.lot" \
      "${base_filename}.toc" \
      "${base_filename}.out" \
      "${base_filename}.fls" \
      "${base_filename}.synctex.gz" \
      "${base_filename}.run.xml" # Файл biber
      # Дополнительно: "${base_filename}.pdf" # Если нужно удалять и PDF
    # Для пакета minted
    rm -rf "_minted-${base_filename}"
    echo "✅ Очистка завершена."
}

# Проверка наличия необходимой команды
check_command_exists() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        echo "❌ Ошибка: Команда '$cmd' не найдена. Пожалуйста, установите её." >&2
        exit 1
    fi
}

# Выполнение команды с логированием и проверкой ошибок
run_command() {
    local cmd_description="$1"
    shift
    local full_command=("$@")

    echo "🔄 Запуск: ${cmd_description}..."
    if ! "${full_command[@]}"; then
        echo "❌ Ошибка при выполнении: ${cmd_description}." >&2
        # Если это ошибка LaTeX и есть лог-файл, показать его хвост
        if [[ "$cmd_description" == *"LaTeX"* && -f "${MAIN_FILE_BASENAME}.log" ]]; then
            echo "🗒️ Последние 20 строк из ${MAIN_FILE_BASENAME}.log:"
            tail -n 20 "${MAIN_FILE_BASENAME}.log" >&2
        fi
        exit 1
    fi
    echo "✅ Успешно: ${cmd_description}."
}

# --- Разбор аргументов командной строки ---
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--latex-compiler)
            DEFAULT_LATEX_COMPILER="$2"
            shift # пропустить аргумент
            shift # пропустить значение
            ;;
        -q|--quiet)
            QUIET_MODE=true
            shift # пропустить аргумент
            ;;
        --clean-after)
            CLEAN_AFTER_BUILD=true
            shift # пропустить аргумент
            ;;
        -C|--clean-only)
            CLEAN_ONLY_MODE=true
            shift # пропустить аргумент
            ;;
        -h|--help)
            usage # usage вызывает exit
            ;;
        -*)
            echo "Неизвестная опция: $1" >&2
            usage # usage вызывает exit
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # сохранить позиционный аргумент
            shift # пропустить аргумент
            ;;
    esac
done

# Восстановить позиционные аргументы
if [[ ${#POSITIONAL_ARGS[@]} -eq 1 ]]; then
    MAIN_FILE_BASENAME="${POSITIONAL_ARGS[0]}"
elif [[ ${#POSITIONAL_ARGS[@]} -gt 1 ]]; then
    echo "Ошибка: Слишком много файлов указано. Укажите только один основной .tex файл." >&2
    usage
elif [[ ${#POSITIONAL_ARGS[@]} -eq 0 && "$CLEAN_ONLY_MODE" = false ]]; then
     echo "Ошибка: Не указано имя основного файла для компиляции." >&2
     usage
elif [[ ${#POSITIONAL_ARGS[@]} -eq 0 && "$CLEAN_ONLY_MODE" = true ]]; then
     echo "Ошибка: Не указано имя основного файла для очистки." >&2
     usage
fi

# Удалить расширение .tex, если оно было указано
MAIN_FILE_BASENAME="${MAIN_FILE_BASENAME%.tex}"


# --- Основная логика ---

# Если указана только очистка
if [[ "$CLEAN_ONLY_MODE" = true ]]; then
    if [[ -z "$MAIN_FILE_BASENAME" ]]; then
        echo "Ошибка: Необходимо указать <имя_основного_файла> для опции --clean-only." >&2
        usage
    fi
    clean_files "$MAIN_FILE_BASENAME"
    exit 0
fi

# Если не указан основной файл для компиляции (и не clean-only)
if [[ -z "$MAIN_FILE_BASENAME" ]]; then
    echo "Ошибка: Не указано <имя_основного_файла> для компиляции." >&2
    usage
fi

# Проверка существования команд, если не только очистка
check_command_exists "$DEFAULT_LATEX_COMPILER"
check_command_exists "biber" # Biber нужен для полной функциональности

# Определение опций для LaTeX и Biber в зависимости от режима quiet
LATEX_RUN_OPTS="-halt-on-error -file-line-error"
BIBER_RUN_OPTS=""

if [[ "$QUIET_MODE" = true ]]; then
    LATEX_RUN_OPTS="-interaction=batchmode ${LATEX_RUN_OPTS}"
    BIBER_RUN_OPTS="--quiet"
else
    LATEX_RUN_OPTS="-interaction=nonstopmode ${LATEX_RUN_OPTS}"
    # BIBER_RUN_OPTS остается пустым для стандартного вывода biber
fi

# Проверка существования основного .tex файла
if [[ ! -f "${MAIN_FILE_BASENAME}.tex" ]]; then
    echo "❌ Ошибка: Файл ${MAIN_FILE_BASENAME}.tex не найден!" >&2
    exit 1
fi

echo "🚀 Начало сборки LaTeX-документа: ${MAIN_FILE_BASENAME}.tex с использованием ${DEFAULT_LATEX_COMPILER}"

# Шаги компиляции
# 1. Первый проход LaTeX
run_command "LaTeX Pass 1 (${DEFAULT_LATEX_COMPILER})" "$DEFAULT_LATEX_COMPILER" $LATEX_RUN_OPTS "${MAIN_FILE_BASENAME}.tex"

# 2. Запуск Biber, если существует .bcf файл
if [[ -f "${MAIN_FILE_BASENAME}.bcf" ]]; then
    run_command "Biber" "biber" $BIBER_RUN_OPTS "$MAIN_FILE_BASENAME" # Biber принимает имя файла без расширения

    # 3. Второй проход LaTeX (после Biber)
    run_command "LaTeX Pass 2 (${DEFAULT_LATEX_COMPILER} после Biber)" "$DEFAULT_LATEX_COMPILER" $LATEX_RUN_OPTS "${MAIN_FILE_BASENAME}.tex"
else
    echo "ℹ️ Файл ${MAIN_FILE_BASENAME}.bcf не найден, пропуск запуска Biber."
fi

# 4. Финальный проход LaTeX (для стабилизации перекрестных ссылок и т.д.)
# Часто требуется еще один проход, особенно после Biber или для сложных документов.
run_command "LaTeX Final Pass (${DEFAULT_LATEX_COMPILER})" "$DEFAULT_LATEX_COMPILER" $LATEX_RUN_OPTS "${MAIN_FILE_BASENAME}.tex"

echo "🎉 Документ LaTeX ${MAIN_FILE_BASENAME}.pdf успешно собран!"

# Очистка после сборки, если указана опция
if [[ "$CLEAN_AFTER_BUILD" = true ]]; then
    clean_files "$MAIN_FILE_BASENAME"
fi

exit 0
