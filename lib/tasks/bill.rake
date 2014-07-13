namespace :bill do
  desc "calculate plot bills every month."
  task :calculate => :environment do
    # puts args[:plot_id]
    # puts args[:day]
    plot = Plot.find(2)
    day = Date.new(2011,7,1)
    while (day<Date.today) do
      puts "day is #{day}"
      _day = Date.new(day.year,day.month,day.day)
      day = _day
      plot.areas.each do |area|
        # logger.info "area is #{area.id}"
        area.houses.each do |house|
          house.create_bill(day, "系统")
        end
      end
      day = day>>1
    end
  end
end