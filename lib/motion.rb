class Motion < Treetop::Runtime::SyntaxNode
  def eval (mode = nil)
    r = eval_simple(motion)
    r = 'select ' + r if mode == 'selection'
    [text_value, r]
  end
  
  def motion_name(motion)
    names = {
      'w' => 'word',
      '(' => 'sentence',
      
      'h' => 'move left',
      '<LEFT>' => 'move left',
      
      'j' => 'move down',
      '<DOWN>' => 'move down',
     
      'k' => 'move up',
      '<UP>' => 'move up',
      
      'l' => 'move right',
      '<RIGHT>' => 'move right',
    }
    return names[motion]
  end
 
  # TODO move to a special class
  def eval_simple(motion)
    text = motion.text_value
    motion_name = motion_name(text)
    quantity_text = quantity.text_value

    if (quantity_text.empty?)
      return motion_name
    end
      
    if (text == 'G' || text == 'gg')
      return "move to line #{quantity_text}"
    end
  
    q = case quantity_text
      when 'a' then 'a'
      when 'i' then 'inner'
      else motion_name += 's' unless quantity_text == '1'; quantity_text
      end
    q + ' ' + motion_name
  end
end
