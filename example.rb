require 'lib/vimmish'

vimtalk = 'iabcde fghij klmn 123<ESC>^2wBc2wbetter now<ESC><RIGHT>Da.<ESC>II can underst<ESC><RIGHT><RIGHT>c<RIGHT>n<ESC>' 
p Vimmish.humanize(vimtalk)
