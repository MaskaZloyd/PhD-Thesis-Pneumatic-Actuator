
-- Функция для удаления \label{...} и \ref{...} из текста
local function remove_commands(text)
  -- Удаляем все вхождения \label{...} и \ref{...}
  text = text:gsub("\\label%b{}", "")
  text = text:gsub("\\ref%b{}", "")
  return text
end

-- Обработка математических блоков (InlineMath и DisplayMath)
function Math(elem)
  elem.text = remove_commands(elem.text)
  return elem
end

-- Обработка сырых блоков (например, RawBlock с LaTeX-кодом)
function RawBlock(elem)
  if elem.format == "latex" then
    elem.text = remove_commands(elem.text)
  end
  return elem
end

-- Обработка сырых встроенных элементов (RawInline)
function RawInline(elem)
  if elem.format == "latex" then
    elem.text = remove_commands(elem.text)
  end
  return elem
end

-- Обработка строковых элементов
function Str(elem)
  elem.text = remove_commands(elem.text)
  return elem
end

-- Удаление всех изображений
function Image(elem)
  -- Возвращаем пустой элемент вместо изображения
  return {}
end

-- Удаление команд \ref{} как отдельного элемента
function Link(elem)
  if elem.content and elem.target:match("^#ref") then
    return {} -- Удаляем только элемент \ref
  end
  return elem
end
