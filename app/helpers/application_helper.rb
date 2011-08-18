module ApplicationHelper
  def all_plots
    Plot.all.map { |p| [p.name, p.id] }
  end

  def get(hash, set_value)
    hash.each do |key, value|
      if key.to_i == set_value
        return value
      end
    end
  end

  def get_boolean(hash, set_value)
    hash.each do |key, value|
      if (key == set_value)
        return value
      end
    end
  end
end
