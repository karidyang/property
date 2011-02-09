module AreasHelper
  def all_plots
    Plot.all.map { |p| [p.name, p.id] }
  end
end
