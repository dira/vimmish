class Macromotion < Treetop::Runtime::SyntaxNode
  def eval (mode = nil)
    r = eval_simple(motion)
    r = 'select ' + r if mode == 'selection'
    [text_value, r]
  end
  
  def motion_name(motion)
    return {
      'G' => 'move to last line (end of file)',
      'gg' => 'move to first line (beginning of file)',
    }[motion]
  end
 
  def eval_simple(motion)
    text = motion.text_value

    motion_name = motion_name(text)
    where_text = where.text_value
    if where_text.empty?
      return motion_name
    else
      return "move to line #{where_text}"
    end
  end
end
