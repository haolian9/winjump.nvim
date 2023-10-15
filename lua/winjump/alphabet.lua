local M = {}

local fn = require("infra.fn")
local utf8 = require("infra.utf8")

local raw = {
  a = [[
 █████╗
██╔══██╗
███████║
██╔══██║
██║  ██║
╚═╝  ╚═╝]],
  b = [[
██████╗
██╔══██╗
██████╔╝
██╔══██╗
██████╔╝
╚═════╝]],
  c = [[
 ██████╗
██╔════╝
██║
██║
╚██████╗
 ╚═════╝]],
  d = [[
██████╗
██╔══██╗
██║  ██║
██║  ██║
██████╔╝
╚═════╝]],
  e = [[
███████╗
██╔════╝
█████╗
██╔══╝
███████╗
╚══════╝]],
  f = [[
███████╗
██╔════╝
█████╗
██╔══╝
██║
╚═╝]],
  g = [[
 ██████╗
██╔════╝
██║  ███╗
██║   ██║
╚██████╔╝
 ╚═════╝]],
  h = [[
██╗  ██╗
██║  ██║
███████║
██╔══██║
██║  ██║
╚═╝  ╚═╝]],
  i = [[
██╗
██║
██║
██║
██║
╚═╝]],
  j = [[
     ██╗
     ██║
     ██║
██   ██║
╚█████╔╝
 ╚════╝]],
  k = [[
██╗  ██╗
██║ ██╔╝
█████╔╝
██╔═██╗
██║  ██╗
╚═╝  ╚═╝]],
  l = [[
██╗
██║
██║
██║
███████╗
╚══════╝]],
  m = [[
███╗   ███╗
████╗ ████║
██╔████╔██║
██║╚██╔╝██║
██║ ╚═╝ ██║
╚═╝     ╚═╝]],
  n = [[
███╗   ██╗
████╗  ██║
██╔██╗ ██║
██║╚██╗██║
██║ ╚████║
╚═╝  ╚═══╝]],
  o = [[
 ██████╗
██╔═══██╗
██║   ██║
██║   ██║
╚██████╔╝
 ╚═════╝]],
  p = [[
██████╗
██╔══██╗
██████╔╝
██╔═══╝
██║
╚═╝]],
  q = [[
 ██████╗
██╔═══██╗
██║   ██║
██║▄▄ ██║
╚██████╔╝
 ╚══▀▀═╝]],
  r = [[
██████╗
██╔══██╗
██████╔╝
██╔══██╗
██║  ██║
╚═╝  ╚═╝]],
  s = [[
███████╗
██╔════╝
███████╗
╚════██║
███████║
╚══════╝]],
  t = [[
████████╗
╚══██╔══╝
   ██║
   ██║
   ██║
   ╚═╝]],
  u = [[
██╗   ██╗
██║   ██║
██║   ██║
██║   ██║
╚██████╔╝
 ╚═════╝]],
  v = [[
██╗   ██╗
██║   ██║
██║   ██║
╚██╗ ██╔╝
 ╚████╔╝
  ╚═══╝]],
  w = [[
██╗    ██╗
██║    ██║
██║ █╗ ██║
██║███╗██║
╚███╔███╔╝
 ╚══╝╚══╝]],
  x = [[
██╗  ██╗
╚██╗██╔╝
 ╚███╔╝
 ██╔██╗
██╔╝ ██╗
╚═╝  ╚═╝]],
  y = [[
██╗   ██╗
╚██╗ ██╔╝
 ╚████╔╝
  ╚██╔╝
   ██║
   ╚═╝]],
  z = [[
███████╗
╚══███╔╝
  ███╔╝
 ███╔╝
███████╗
╚══════╝]],
}

local matrix = {}
for char, str in pairs(raw) do
  local lines = {}
  for line in fn.split_iter(str, "\n") do
    table.insert(lines, fn.tolist(utf8.iterate(line)))
  end
  matrix[char] = lines
end

local size = {}
do
  for char, lines in pairs(matrix) do
    local width = 0
    for _, line in ipairs(lines) do
      if #line > width then width = #line end
    end
    size[char] = { width = width, height = #lines }
  end
end

---@param letter string @letter
---@return string
function M.raw(letter) return assert(raw[letter]) end

---@param letter string @letter
---@return string[][]
function M.matrix(letter) return assert(matrix[letter]) end

---@param letter string @letter
---@return {width: integer, height: integer} @max-width, height
function M.size(letter) return assert(size[letter]) end

return M
