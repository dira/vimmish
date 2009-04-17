module Command
  def eval (mode = nil)
    case text_value
      when 'c' then 'change'
      when 'd' then 'delete'
      when 'y' then 'yank'
      
      when 'x' then 'delete a character'
      when 'dd' then 'delete current line'
      when 'D' then 'delete the rest of the current line'
      when 'J' then 'unite the current line with the next one'
      when '~' then 'change character case'
      when 'gv' then 're-select previous selection'
      
      when 'cc' then 'change current line with: '
      when 's' then 'substitute character with: '
      when 'S' then 'substitute line with: '
      when 'C' then 'change the rest of the current line with: ' 
      
      when 'i' then 'insert before cursor: '
      when 'I' then 'insert to the begining of the current line: '
      when 'a' then 'append after cursor: '
      when 'A' then 'append to the end of the current line: '
      when 'o' then 'open a new line below and insert: '
      when 'O' then 'open a new line above and insert: '
    end + (mode == 'selection' ? ' selection' : '')
  end
end
