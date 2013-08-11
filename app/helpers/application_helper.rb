module ApplicationHelper

  def image_tag(source, options = {})
    source = 'blank_image.jpg' if source.blank?
    super(source, options)
  end

  def bread_crumbs(steps)
    html_steps = []
    steps.each{ |url| html_steps << content_tag(:span, url, :class => 'short_link') }
    hint = content_tag(:span, (t('chosen_brand') + ': '), :class => 'short_link')
    links = raw( hint + raw(html_steps.join) )

    path_link = content_tag(:div, links, :class => 'path_link')
    content_tag(:div, path_link, :id => 'brad_crams', :itemprop => 'breadcrumb')
  end
end
