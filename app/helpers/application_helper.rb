module ApplicationHelper


  def build_advanced_searh_url(brand, category, sub_category, gender)
    #"/advanced_search/#b=#{brand.brand_id}
    url = "/advanced_search/#"
    url += "b=#{brand}" if brand
    url += "cat=#{category}" if category
    url += "sub=#{sub_category}" if sub_category
    url += "g=#{gender}" if gender
    url
  end
end
