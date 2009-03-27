module Command
  def eval (mode = nil)
    case text_value
      when 'c' then 'change'
      when 'd' then 'delete'
      when 'y' then 'yank'
    end + (mode == 'selection' ? ' selection' : '')
  end
end