#coding:utf-8
class InitData < ActiveRecord::Migration
  def self.up
    company = Company.create(:name=>'铭智物业')
    company.save
    plot = Plot.create(:name=>'岷江花园',:company_id=>company.id)
    plot.save
    area = Area.create(:name=>'01号楼',:plot_id=>plot.id)
    area.save
    5.times do |index|
      house = House.create(:house_code=>"1-1-1-#{index}",:use_type=>1,:status=>1,
                           :plot_id=>plot.id,:area_id=>area.id,:unit_id=>1)
      house.save
    end
    5.times do |index|
      house = House.create(:house_code=>"1-1-2-#{index}",:use_type=>1,:status=>1,
                           :plot_id=>plot.id,:area_id=>area.id,:unit_id=>2)
      house.save
    end
    charge = Charge.create(:item_name=>'物业管理费',:period=>2,:period_type=>1,:plot_id=>plot.id,:unit_type=>1,
                           :fee_rate=>0,:item_num=>1,:price=>0.5,:return_back=>0)
    charge.save

  end

  def self.down
    Charge.delete_all
    House.delete_all
    Area.delete_all
    Plot.delete_all
    Company.delete_all
  end
end
