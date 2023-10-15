some ways to jump between nvim windows

![](https://user-images.githubusercontent.com/6236829/275310774-bbfece58-d92c-4ec8-b077-3498ee96471a.jpg)

## features
* jumping by given winnr
* jumping in 'tmux display-panes' way


## status
* it just works(tm)
* it is feature-frozen


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
