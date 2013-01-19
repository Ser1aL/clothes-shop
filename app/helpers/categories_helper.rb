module CategoriesHelper

  def set_meta(name)
    content_for :meta_title, t("meta.#{name}.meta_title")
    content_for :meta_description, t("meta.#{name}.meta_description")
    content_for :meta_keywords, t("meta.#{name}.meta_keywords")
    content_for :seo_header, t("meta.#{name}.seo_header")
  end

end
