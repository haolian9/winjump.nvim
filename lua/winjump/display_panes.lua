--[[
考虑点：
* floatwin
* win visible: partial?
* hint/label
  * char set: winnr -> a-z
  * color
  * drawer

实现：
* fullscreen floatwin
* draw the skeleton
* replaceable label
  * 方块: 长宽
]]
--

local Ephemeral = require("infra.Ephemeral")
local fn = require("infra.fn")
local jelly = require("infra.jellyfish")("winjump.display_panes", "debug")
local bufmap = require("infra.keymap.buffer")
local prefer = require("infra.prefer")
local rifts = require("infra.rifts")

local alphabet = require("winjump.alphabet")

local api = vim.api

local build_matrix
do
  ---@class WinInfo
  ---@field botline   integer @last complete displayed buffer line
  ---@field bufnr     integer @number of buffer in the window
  ---@field height    integer @window height (excluding winbar)
  ---@field loclist   integer @1 if showing a location list
  ---@field quickfix  integer @1 if quickfix or location list window
  ---@field terminal  integer @1 if a terminal window
  ---@field tabnr     integer @tab page number
  ---@field topline   integer @first displayed buffer line
  ---@field variables any     @a reference to the dictionary with window-local variables
  ---@field width     integer @window width
  ---@field winbar    integer @1 if the window has a toolbar, 0 otherwise
  ---@field wincol    integer @leftmost screen column of the window; "col" from |win_screenpos()|
  ---@field textoff   integer @number of columns occupied by any 'foldcolumn', 'signcolumn' and line number in front of the text
  ---@field winid     integer @|window-ID|
  ---@field winnr     integer @window number
  ---@field winrow    integer @topmost screen line of the window; "row" from |win_screenpos()|

  ---@return fun(): WinInfo?
  local function iter_tab_wi()
    local tabnr = vim.fn.tabpagenr()
    return fn.filter(function(wi) return wi.tabnr == tabnr end, vim.fn.getwininfo())
  end

  local chars = { vertical = "|", horizon = "-", vertex = "*", blank = " " }

  ---@return string[][]
  local function zero_matrix()
    local zero = {}

    --todo: laststatus={0,1,2,3}
    --todo: tabline, statusline, cmdline
    local rows = vim.go.lines
    rows = rows - vim.go.cmdheight

    local cols = vim.go.columns

    for row = 1, rows do
      local line = {}
      for col = 1, cols do
        line[col] = chars.blank
      end
      zero[row] = line
    end

    return zero
  end

  ---@param matrix string[][]
  ---@param wi WinInfo
  local function draw_win(matrix, wi)
    --todo: tabline, off-by-1
    if false and wi.winrow ~= 1 then -- draw top border
      local row = wi.winrow - 1
      local top = assert(matrix[row])
      local col_start = wi.wincol - 1
      local col_stop = col_start + wi.width + wi.textoff
      for col = col_start, col_stop do
        top[col] = chars.horizon
      end
      --todo: vertex
      --if col_start ~= 1 then top[col_start] = chars.vertex end
    end
    if false and wi.wincol ~= 1 then -- draw left border
      local row_start = wi.winrow
      local row_stop = row_start + wi.height
      local col = wi.wincol - 1
      for row = row_start, row_stop do
        matrix[row][col] = chars.vertical
      end
      --todo: vertex
      --if row_start ~= 1 then matrix[row_start][col] = chars.vertex end
    end
    do -- draw letter
      local a = string.char(string.byte("a") + (wi.winnr - 1))
      local letter = alphabet.matrix(a)
      local size = alphabet.size(a)
      local start_col = wi.wincol + math.floor((wi.width - size.width) / 2)
      local start_row = wi.winrow + math.floor((wi.height - size.height) / 2)
      for row, letter_line in ipairs(letter) do
        local matrix_line = matrix[start_row + row - 1]
        for col, char in ipairs(letter_line) do
          matrix_line[start_col + col - 1] = char
        end
      end
    end
  end

  function build_matrix()
    local matrix = zero_matrix()

    for wi in iter_tab_wi() do
      draw_win(matrix, wi)
    end

    return matrix
  end
end

return function()
  local bufnr
  do
    local matrix = build_matrix()
    local lines = {}
    for i, line in ipairs(matrix) do
      lines[i] = table.concat(line, "")
    end
    bufnr = Ephemeral({ modifiable = true, handyclose = true }, lines)
  end

  do
    local bm = bufmap.wraps(bufnr)
    for i = string.byte("a"), string.byte("z") do
      bm.n(string.char(i), function()
        api.nvim_win_close(0, false)
        local to_winnr = i - string.byte("a") + 1
        local to_winid = vim.fn.win_getid(to_winnr)
        if to_winid == 0 then return end
        api.nvim_set_current_win(to_winid)
      end)
    end
  end

  do
    local winid = rifts.open.fullscreen(bufnr, true, { relative = "editor" })
    local wo = prefer.win(winid)
    wo.list = false
    wo.winblend = 1
  end
end
