class Motion < Treetop::Runtime::SyntaxNode
  def eval (mode = nil)
    @text = motion.text_value
    @translation = Motion.translation(@text)

    @name = get_name(@translation)
    begin
      @how_many_times = quantity.text_value
    rescue
      @how_many_times = nil
    end

    result = apply_quantity
    result = apply_mode(result, text_value, mode)
 end

private
  def pluralize(what, how_many)
    return what + (how_many != 1 ? 's' : '')
  end

  def apply_quantity
    if (@how_many_times.nil? || @how_many_times.empty?)
      return @name;
    end
    if (@how_many_times.to_i != 0)
      quantity_value = @how_many_times.to_i
      if (@text == '^')
        q = '' #ignore count
      elsif (@text == '$')
        # special count
        q = " that is #{quantity_value - 1} lines below" if quantity_value > 1
      else
        q = ", #{@how_many_times} #{pluralize('time', @how_many_times)}" if quantity_value > 1
      end
      return "#{@name}#{q}"
    else 
      quantity_value = {
        'a' => 'a', 
        'i' => 'inner'
      }[@how_many_times]
      return "#{quantity_value} #{@translation[1][:special_count]}"
    end
  end

  def get_name(translation)
    translation && (translation.respond_to? :flatten) ? translation[0] : translation
  end

  def self.translation(motion_text)
    word_motions_translations = {
      'w'  => ['to the begining of the next word'],
      'W'  => ['to the begining of the next space-separated word'],
      'b'  => ['to the begining of the previous word'],
      'B'  => ['backwards one space-separated-word'],
      'e'  => ['to the end of the next word'],
      'E'  => ['to the end of the next space-separated-word'],
      'ge' => ['to the end of the previous word'],
      'gE' => ['to the end of the previous space-separated-word'],
    }
    word_motions_translations.each_pair{|key, motion| motion[1] = { :special_count => "word" }}
  
    translations = {
      '0' => 'to the begining of the line',
      '^' => 'to the begining of the line (not blank character)',
      '$' => 'to the end of the line',

      '%' => 'to the matching paranthesys',
      '(' => 'sentence',
      
      'h' => 'one character to the left',
      '<LEFT>' => 'one character to the left',
      
      'j' => 'down',
      '<DOWN>' => 'down',
     
      'k' => 'up',
      '<UP>' => 'up',
      
      'l' => 'one character to the right',
      '<RIGHT>' => 'one character to the right',

      ';' => ['repeat last character find', {:modes => { nil => '' }}],
    }
    translations = translations.merge(word_motions_translations)
    translations[motion_text]
  end

  def apply_mode(result, text, mode)
    modes = {
      nil => 'move ',
      :command => '',
      :selection => 'select ',
    }.merge(get_mode(@translation))
    [[text, "#{modes[mode]}#{result}"]]
  end

  def get_mode(translation) 
    if (translation.respond_to? :flatten) && translation[1] && translation[1][:modes]
      translation[1][:modes]
    else
      {}
    end
  end
end
