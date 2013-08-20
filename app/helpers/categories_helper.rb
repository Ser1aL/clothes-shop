module CategoriesHelper

  PARAMS_TO_PATHS = [
    { params: [:top_level_cat_id], path: :category_path },
    { params: [:brand, :top_level_cat_id], path: :category_brand_path },
    { params: [:gender, :top_level_cat_id], path: :category_gender_path },
    { params: [:brand, :gender, :top_level_cat_id], path: :category_gender_brand_path },
    { params: [:category, :gender, :top_level_cat_id], path: :category_gender_sub_category_path },
    { params: [:category, :top_level_cat_id], path: :category_sub_category_path },
    { params: [:brand, :category, :top_level_cat_id], path: :category_sub_category_with_brand_path },
    { params: [:category, :sub_category, :top_level_cat_id], path: :category_sub_category_with_sub_path }
  ]


  def set_meta(name)
    content_for :meta_title, t("meta.#{name}.meta_title")
    content_for :meta_description, t("meta.#{name}.meta_description")
    content_for :meta_keywords, t("meta.#{name}.meta_keywords")
    content_for :seo_header, t("meta.#{name}.seo_header")
  end

  def build_uri(params, set_stop = false)
    params.symbolize_keys! unless params.is_a? ActiveSupport::HashWithIndifferentAccess
    route = ''
    highest_match = 0
    PARAMS_TO_PATHS.each do |route_set|
      if ((params.keys.map(&:to_sym) & route_set[:params]).sort == route_set[:params].sort) && (highest_match < route_set[:params].size)
        route = route_set[:path]
        highest_match = route_set[:params].size
      end
    end

    exit if set_stop

    return if route.blank?

    send(route, params)
  end

end
