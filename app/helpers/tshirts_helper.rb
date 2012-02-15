module TshirtsHelper
  def list_words( indices )
    if indices.respond_to?(:map)
      indices.map { |i|
        "'" + @tshirt.caption.split[i].to_s.downcase + "'"
      }.join(", ")
    end
  end
end
