class Event < ActiveRecord::Base
  belongs_to :user
  has_many :questionnaires
  has_many :table_arranges

  def self.except_attr_for_view
    return [:city, :district, :address]
  end

  def as_json(options={})
    if options.fetch(:view, false)
      hash = super(:except => Event.except_attr_for_view)
      hash[:full_address] = self.city.to_s + self.district.to_s + self.address.to_s if self.has_location
      return hash
    else
      super(options)
    end
  end

  def find_by_name(table_name)
    return table_arranges.select{|t| t.name == table_name}.first rescue nil
  end

  #吐json時會用到的include(不包含問卷內問題)
  def self.include_without_q_for_json
    return {:questionnaires=>{:methods => [:guest_replies,:guest_groups]}, :table_arranges=>{}}
  end

  #includes除了問卷題目
  def self.includes_without_q
    return [{:questionnaires=>[:guest_replies,:guest_groups]}, :table_arranges]
  end

  def self.get_valid_params(p)
    return nil if p[:name].nil? or p[:holding_date].nil? or p[:date_start].nil? or p[:date_end].nil? or p[:has_location].nil?
    return nil if p[:name]==""  or p[:holding_date]=="" or p[:date_start]=="" or p[:date_end]=="" or p[:has_location]==""
    has_location = p[:has_location].to_b
    return nil if (has_location and (p[:city].nil? or p[:district].nil? or p[:address].nil? or p[:place_name].nil?))
    return nil if (has_location and (p[:city]=="" or p[:district]=="" or p[:address]=="" or p[:place_name]==""))
    p[:has_location] = has_location
    holding_date = p[:holding_date].to_datetime rescue nil
    return nil if holding_date.nil?
    p[:holding_date] = holding_date
    date_start = p[:date_start].to_datetime rescue nil
    date_end   = p[:date_end].to_datetime   rescue nil
    return nil if date_start.nil? or date_end.nil?
    return nil if date_start.nil? or date_end.nil?
    return nil if date_end > date_start
    p[:date_start] = date_start
    p[:date_end]   = date_end
    return p
  end

end
