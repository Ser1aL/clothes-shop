class Brand < ActiveRecord::Base
  has_many :item_models
  has_many :image_attachments, :as => :association
  validates_presence_of :name

  def self.find_by_letter(letter)
    Brand.where("brands.name LIKE '#{letter.capitalize}%'")
  end

  def name
    display_name.blank? ? super.gsub('&#8482;', ' TM ').gsub('&#174;', ' (R) ') : display_name
  end

  def build_category_tree
    tree = { :root => {} }

    CategoryCounting.where(:brand_id => self.id).group_by(&:category_id).each do |category_id, countings|
      tree[:root][countings.first.category_name] = {
          :category => Category.find(category_id),
          :count => countings.map(&:value).sum,
          :tree => []
      }
      countings.each do |counting|
        next if tree[:root][countings.first.category_name][:tree].map{|node| node[:id]}.include?(counting.sub_category_id)
        if counting.sub_category_name.present?
          if tree[:root][countings.first.category_name][:tree].select { |node| node[:name] == counting.sub_category_name }.blank?
            tree[:root][countings.first.category_name][:tree] << {
                :sub_category => SubCategory.find(counting.sub_category_id),
                :name => counting.sub_category_name,
                :count => counting.value
            }
          end
        end
      end
    end
    tree
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

end
