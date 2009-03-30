class Motion < Treetop::Runtime::SyntaxNode
  def eval (mode = nil)
    r = eval_simple(motion)
    mode_part = {
      nil => 'move ',
      :command => '',
      :selection => 'select ',
    }[mode]
    r = "#{mode_part}#{r}"
    [text_value, r]
  end
  
  def motion_name(motion)
    names = {
      'w' => ['to the begining of the next word', 'word'],
      'b' => ['to the begining of the previous word', 'word'],
      'B' => ['backwards one space-separated-word', 'word'],
      'e' => ['to the end of the next word', 'word'],
      'E' => ['to the end of the next space-separated-word', 'word'],
      'ge' => ['to the end of the previous word', 'word'],
      'gE' => ['to the end of the previous space-separated-word', 'word'],

      '0' => 'to the begining of the line',
      '^' => 'to the begining of the line (not blank character)',
      '$' => 'to the end of the line',

      '%' => 'to the matching paranthesys',
      '(' => 'sentence',
      
      'h' => 'left',
      '<LEFT>' => 'left',
      
      'j' => 'down',
      '<DOWN>' => 'down',
     
      'k' => 'up',
      '<UP>' => 'up',
      
      'l' => 'right',
      '<RIGHT>' => 'right',
    }
    return names[motion]
  end
     
  # TODO move to a special class
  def eval_simple(motion)
    text = motion.text_value
    motion_name = motion_name(text)
    motion_name = motion_name[0] if motion_name.respond_to? :flatten
    begin
      quantity_text = quantity.text_value
    rescue
      nil
    end

    result = motion_name
    if (quantity_text.nil? || quantity_text.empty?)
      return result
    end
      
    if (quantity_text.to_i != 0)
      quantity_value = quantity_text.to_i
      if (text == '^')
        q = '' #ignore count
      elsif (text == '$')
        # special count
        q = " that is #{quantity_value - 1} lines below" if quantity_value > 1
      else
        q = ", #{quantity_text} #{pluralize('time', quantity_text)}" if quantity_value > 1
      end
      "#{motion_name}#{q}"
    else 
      quantity_value = {'a' => 'a', 'i' => 'inner'}[quantity_text]
      "#{quantity_value} #{motion_name(text)[1]}"
    end
 end

private
  def pluralize(what, how_many)
    return what + (how_many != 1 ? 's' : '')
  end
end
