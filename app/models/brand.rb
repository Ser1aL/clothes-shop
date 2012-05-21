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
    Category.all.each do |category|
      tree[:root][category.name] = {
        :id => category.id,
        :count => self.item_models.find_all_by_category_id(category.id).count,
        :tree => []
      }
      SubCategory.all.each do |sub_category|
        tree[:root][category.name][:tree] << {
            :id => sub_category.id,
            :name => sub_category.name,
            :count => self.item_models.find_all_by_category_id_and_sub_category_id(category.id, sub_category.id).count
        }
      end
    end
    tree
  end
end
