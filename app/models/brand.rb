class Brand < ActiveRecord::Base
  has_many :item_models
  has_many :image_attachments, :as => :association
  validates_presence_of :name

  def self.find_by_letter(letter)
    Brand.where("brands.name LIKE '#{letter.capitalize}%'")
  end

  def name
    display_name.blank? ? super : display_name
  end

  def build_category_tree
    tree = { :root => {} }

    CategoryCounting.where(:brand_id => self.id).group_by(&:category_id).each do |category_id, countings|
      tree[:root][countings.first.category_name] = {
          :id => category_id,
          :count => countings.map(&:value).sum,
          :tree => []
      }
      countings.each do |counting|
        tree[:root][countings.first.category_name][:tree] << {
            :id => counting.sub_category_id,
            :name => counting.sub_category_name,
            :count => counting.value
        } if counting.sub_category_name.present?
      end
    end
    tree
  end
end
