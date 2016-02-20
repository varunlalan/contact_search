class SearchContact
  NUMBER_MAPPING = {
    '2' => %w(a b c),
    '3' => %w(d e f),
    '4' => %w(g h i),
    '5' => %w(j k l),
    '6' => %w(m n o),
    '7' => %w(p q r s),
    '8' => %w(t u v),
    '9' => %w(w x y z)
  }

  def initialize(search_string)
    @search_string = search_string
    @split_string = split_search_string
    @phone_regex = phone_regex
    @name_regex = nil
    @conditions = []
  end

  def search
    @conditions << search_by_phone_number
    @conditions << search_by_name

    results = Contact.where(@conditions.reject(&:blank?).join(' OR '))

    results || []
  end

  private

  def split_search_string
    @search_string.gsub(/\*|\+|#/, '').split('')
  end

  def search_by_name
    return "" if '1'.in?(@split_string) || '0'.in?(@split_string)
    @name_regex = name_regex
    "lower(first_name) ~ '#{@name_regex}' OR lower(last_name) ~ '#{@name_regex}'"
  end

  def search_by_phone_number
    "phone_number ~ '#{@phone_regex}'"
  end

  def name_regex
    regex = @split_string.map do |char|
      "(#{NUMBER_MAPPING[char].join('|')})"
    end.join('')

    "^#{regex}"
  end

  def phone_regex
    @split_string.join("[^\\d]*")
  end
end
