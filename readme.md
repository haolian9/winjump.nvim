some ways to jump between nvim windows


## features
* jumping by given winnr
* jumping in 'tmux display-panes' way


## status
* usable
* but there are some edge cases need to be addressed


## prerequisites
* haolian9/infra.nvim


## usage
that's how i use it
```
for i = 1, 9 do
  m.n("<leader>" .. i, function() require("winjump").to(i) end)
end
m.n("<leader>0", function() require("winjump").display_panes() end)
```


## credits
* all the fonts used in this plugin come from http://patorjk.com/software/taag/
