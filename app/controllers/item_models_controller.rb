class ItemModelsController < ApplicationController
  def index
    @categories = Category.all.group_by(&:top_category).delete_if{ |key, _| key.blank? }
    @countings = CategoryCounting.grouped_by_category
    @banners = Banner.where("category_id IS NULL")
  end

  def show
    @product = ItemModel.find(params[:id])
    @style = @product.product.styles.find(params[:style_id])
    familiars_total_count = @product.category.item_models.count
    @familiars = ItemModel.where('item_models.id != ? and category_id = ?', @product.id, @product.category.id).joins(:product => :styles).where('styles.hidden = 0').limit(3).offset(rand(familiars_total_count - 3))
  end

  def preload
    prepare_counts_with_conditions
    @item_models = ItemModel.get_items(params)
  end

  def search
    params[:q].gsub!("+", " ")
    @products = ItemModel.search(params[:q], :page => params[:page])
    @products.reject! { |product| product.product.styles.blank? }
  end

  private

  def prepare_counts_with_conditions
    @brand_counts = CategoryCounting.counts_with_favorite(:brand, params)
    @brand_total_counts = @brand_counts.map{|hash| hash['item_count']}.sum

    @category_counts = CategoryCounting.counts_with_favorite(:category, params)
    @category_total_counts = @category_counts.map{|hash| hash['item_count']}.sum

    @sub_category_counts = CategoryCounting.counts_with_favorite(:sub_category, params)
    @sub_category_total_counts = @sub_category_counts.map{|hash| hash['item_count']}.sum

    @gender_counts = CategoryCounting.counts_with_favorite(:gender, params)
    @gender_total_counts = @gender_counts.map{|hash| hash['item_count']}.sum
  end

  #def update_prices(item_model, style)
  #  exists_at_6pm, exists_at_zappos = true, true
  #  begin
  #    exists_at_6pm = false unless style.update_6pm_prices(item_model)
  #  rescue => e
  #    Rails.logger.debug '---------GOT 6pm EXCEPTION---------------'
  #    Rails.logger.debug e.inspect
  #    Rails.logger.debug e.message
  #    Rails.logger.debug '------------------------'
  #  end
  #  begin
  #    if style.update_zappos_prices(item_model)
  #    else
  #      exists_at_zappos = false
  #    end
  #  rescue => e
  #    Rails.logger.debug '---------GOT zappos EXCEPTION---------------'
  #    Rails.logger.debug e.inspect
  #    Rails.logger.debug e.message
  #    Rails.logger.debug '------------------------'
  #  end
  #
  #  if exists_at_6pm || exists_at_zappos
  #    style.update_attribute(:hidden, false)
  #  else
  #    style.update_attribute(:hidden, true)
  #  end
  #end

end
