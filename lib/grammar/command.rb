module Command
  def eval (mode = nil)
    translations = {
      'c' => 'change',
      'd' => 'delete',
      'y' => 'yank',

      'x' => 'delete a character',
      'dd' => 'delete current line',
      'D' => 'delete the rest of the current line',
      'J' => 'unite the current line with the next one',
      '~' => {:default => 'change character case', :selection => false},
      'gv' => 're-select previous selection',

      'cc' => 'change current line with: ',
      's' => 'substitute character with: ',
      'S' => 'substitute line with: ',
      'C' => 'change the rest of the current line with: ' ,

      'i' => 'insert before cursor: ',
      'I' => 'insert to the begining of the current line: ',
      'a' => 'append after cursor: ',
      'A' => 'append to the end of the current line: ',
      'o' => 'open a new line below and insert: ',
      'O' => 'open a new line above and insert: ',
    }
    result = translations[text_value]
    if (result.respond_to? :swapcase)
      result + (mode == 'selection' ? ' selection' : '')
    else
      if (!mode.nil? && result[mode])
        result[mode]
      else
        result[:default]
      end
    end
  end
end
