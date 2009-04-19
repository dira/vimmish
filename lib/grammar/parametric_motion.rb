class ParametricMotion < Treetop::Runtime::SyntaxNode
  def eval (mode = nil)
    r = eval_simple(motion)
    r = 'select ' + r if mode == 'selection'
    [[text_value, r]]
  end
  
  def motion_name(motion)
    names = {
      'f' => 'move on the next #{character}',
      'F' => 'move on the previous #{character}',
      't' => 'move before the next #{character}',
      'T' => 'move before the previous #{character}',
      ';' => 'repeat the last character find',
    }
    return names[motion]
  end
     
  # TODO move to a special class
  def eval_simple(motion)
    text = motion.text_value
    motion_name = motion_name(text)
    character = param.text_value

    result = Kernel.eval("\"#{motion_name}\"")
    quantity_text = quantity.text_value

    if (quantity_text.empty?)
      return result
    end
    
    result += ", #{quantity_text} time"
    result += 's' unless quantity_text == '1'
  end
end
