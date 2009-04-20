require 'lib/vimmish'
require 'pp'

vimmish = "iDon't know vim :(.<ESC>^2WBc2wbetter now<ESC><RIGHT>Da.<ESC>II can understan<ESC><RIGHT>~dE"
humanized = Vimmish.humanize(vimmish)

pp humanized
pp VimmishFormatters.pretty(humanized)
