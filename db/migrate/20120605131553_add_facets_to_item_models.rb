class AddFacetsToItemModels < ActiveRecord::Migration
  def self.up
    add_column :item_models, :txAttrFacet_Materials, :string
    add_column :item_models, :txAttrFacet_Verticals, :string
    add_column :item_models, :txAttrFacet_Closures, :string
    add_column :item_models, :txAttrFacet_Occasion, :string
    add_column :item_models, :txAttrFacet_Performance, :string
    add_column :item_models, :txAttrFacet_Styles, :string
    add_column :item_models, :txAttrFacet_Features, :string
    add_column :item_models, :txAttrFacet_StraporHandleStyle, :string
    add_column :item_models, :txAttrFacet_Promo, :string
    add_column :item_models, :txAttrFacet_Theme, :string
    add_column :item_models, :txAttrFacet_Care, :string
    add_column :item_models, :txAttrFacet_SwimsuitStyles, :string
    add_column :item_models, :txAttrFacet_ShortsInseam, :string
    add_column :item_models, :txAttrFacet_Pattern, :string
    add_column :item_models, :txAttrFacet_PantStyles, :string
    add_column :item_models, :txAttrFacet_JeansFit, :string
    add_column :item_models, :txAttrFacet_Accents, :string
    add_column :item_models, :txAttrFacet_Pockets, :string
    add_column :item_models, :txAttrFacet_DenimType, :string
    add_column :item_models, :txAttrFacet_Rise, :string
    add_column :item_models, :txAttrFacet_SkirtStyles, :string
    add_column :item_models, :txAttrFacet_Insole, :string
    add_column :item_models, :txAttrFacet_Lining, :string
    add_column :item_models, :txAttrFacet_ShoeToeStyle, :string
    add_column :item_models, :txAttrFacet_BootShaft, :string
    add_column :item_models, :txAttrFacet_ShoeWeight, :string
    add_column :item_models, :txAttrFacet_WaterResistance, :string
    add_column :item_models, :txAttrFacet_FaceShape, :string
    add_column :item_models, :txAttrFacet_Display, :string
    add_column :item_models, :txAttrFacet_Trend, :string
    add_column :item_models, :txAttrFacet_HatTypes, :string
    add_column :item_models, :txAttrFacet_Gender, :string
    add_column :item_models, :txAttrFacet_TopStyles, :string
    add_column :item_models, :txAttrFacet_CollarStyle, :string
    add_column :item_models, :txAttrFacet_CountryofOrigin, :string
    add_column :item_models, :txAttrFacet_HeelStyle, :string
    add_column :item_models, :txAttrFacet_SleeveLength, :string
    add_column :item_models, :txAttrFacet_UnderwearStyles, :string
    add_column :item_models, :txAttrFacet_BraType, :string
    add_column :item_models, :txAttrFacet_WeddingParty, :string
    add_column :item_models, :txAttrFacet_SkirtLength, :string
    add_column :item_models, :txAttrFacet_ShortStyles, :string
    add_column :item_models, :txAttrFacet_DressTypes, :string
    add_column :item_models, :txAttrFacet_SpecialtySizes, :string
    add_column :item_models, :txAttrFacet_BagFrames, :string
    add_column :item_models, :txAttrFacet_SockLengths, :string
    add_column :item_models, :txAttrFacet_ProductCompatibility, :string
    add_column :item_models, :txAttrFacet_SockStyles, :string
    add_column :item_models, :txAttrFacet_FitAssist, :string
    add_column :item_models, :txAttrFacet_PerformanceShoeSupportType, :string
    add_column :item_models, :txAttrFacet_JacketTypes, :string
    add_column :item_models, :txAttrFacet_Fill, :string
    add_column :item_models, :txAttrFacet_BagSize, :string
    add_column :item_models, :txAttrFacet_Movement, :string
    add_column :item_models, :txAttrFacet_Treatments, :string

    add_column :item_models, :facet_loaded, :boolean, :default => false
  end

  def self.down
    remove_column :item_models, :txAttrFacet_Materials
    remove_column :item_models, :txAttrFacet_Verticals
    remove_column :item_models, :txAttrFacet_Closures
    remove_column :item_models, :txAttrFacet_Occasion
    remove_column :item_models, :txAttrFacet_Performance
    remove_column :item_models, :txAttrFacet_Styles
    remove_column :item_models, :txAttrFacet_Features
    remove_column :item_models, :txAttrFacet_StraporHandleStyle
    remove_column :item_models, :txAttrFacet_Promo
    remove_column :item_models, :txAttrFacet_Theme
    remove_column :item_models, :txAttrFacet_Care
    remove_column :item_models, :txAttrFacet_SwimsuitStyles
    remove_column :item_models, :txAttrFacet_ShortsInseam
    remove_column :item_models, :txAttrFacet_Pattern
    remove_column :item_models, :txAttrFacet_PantStyles
    remove_column :item_models, :txAttrFacet_JeansFit
    remove_column :item_models, :txAttrFacet_Accents
    remove_column :item_models, :txAttrFacet_Pockets
    remove_column :item_models, :txAttrFacet_DenimType
    remove_column :item_models, :txAttrFacet_Rise
    remove_column :item_models, :txAttrFacet_SkirtStyles
    remove_column :item_models, :txAttrFacet_Insole
    remove_column :item_models, :txAttrFacet_Lining
    remove_column :item_models, :txAttrFacet_ShoeToeStyle
    remove_column :item_models, :txAttrFacet_BootShaft
    remove_column :item_models, :txAttrFacet_ShoeWeight
    remove_column :item_models, :txAttrFacet_WaterResistance
    remove_column :item_models, :txAttrFacet_FaceShape
    remove_column :item_models, :txAttrFacet_Display
    remove_column :item_models, :txAttrFacet_Trend
    remove_column :item_models, :txAttrFacet_HatTypes
    remove_column :item_models, :txAttrFacet_Gender
    remove_column :item_models, :txAttrFacet_TopStyles
    remove_column :item_models, :txAttrFacet_CollarStyle
    remove_column :item_models, :txAttrFacet_CountryofOrigin
    remove_column :item_models, :txAttrFacet_HeelStyle
    remove_column :item_models, :txAttrFacet_SleeveLength
    remove_column :item_models, :txAttrFacet_UnderwearStyles
    remove_column :item_models, :txAttrFacet_BraType
    remove_column :item_models, :txAttrFacet_WeddingParty
    remove_column :item_models, :txAttrFacet_SkirtLength
    remove_column :item_models, :txAttrFacet_ShortStyles
    remove_column :item_models, :txAttrFacet_SpecialtySizes
    remove_column :item_models, :txAttrFacet_DressTypes
    remove_column :item_models, :txAttrFacet_BagFrames
    remove_column :item_models, :txAttrFacet_SockLengths
    remove_column :item_models, :txAttrFacet_ProductCompatibility
    remove_column :item_models, :txAttrFacet_SockStyles
    remove_column :item_models, :txAttrFacet_FitAssist
    remove_column :item_models, :txAttrFacet_PerformanceShoeSupportType
    remove_column :item_models, :txAttrFacet_JacketTypes
    remove_column :item_models, :txAttrFacet_Fill
    remove_column :item_models, :txAttrFacet_BagSize
    remove_column :item_models, :txAttrFacet_Movement
    remove_column :item_models, :txAttrFacet_Treatments

    remove_column :item_models, :facet_loaded
  end
end
