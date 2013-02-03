module ApplicationHelper

  def image_tag(source, options = {})
    source ||= 'blank_image.jpg'
    super(source, options)
  end

  def build_advanced_searh_url(brand, category, sub_category, gender)
    #"/advanced_search/#b=#{brand.brand_id}
    url = "/advanced_search/#"
    url += "b=#{brand}" if brand
    url += "cat=#{category}" if category
    url += "sub=#{sub_category}" if sub_category
    url += "g=#{gender}" if gender
    url
  end

  def bread_crumbs(steps)
    html_steps = []
    steps.each{ |url| html_steps << content_tag(:span, url, :class => 'short_link') }
    hint = content_tag(:span, (t('chosen_brand') + ': '), :class => 'short_link')
    links = raw( hint + raw(html_steps.join) )

    path_link = content_tag(:div, links, :class => 'path_link')
    content_tag(:div, path_link, :id => 'brad_crams')
  end
end
