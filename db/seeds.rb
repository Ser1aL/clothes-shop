# encoding: utf-8

ExchangeRate.create!(:value => 8, :domain => '', :currency => 'грн.', :markup => 10)
ExchangeRate.create!(:value => 8, :domain => 'mydostavka.com.ua', :currency => 'грн.', :markup => 10)
StaticPage.create!(:name => 'about_us', :human_name => 'О нас', :text => 'Lorem Ipsum')
StaticPage.create!(:name => 'reviews', :human_name => 'Отзывы', :text => 'Lorem Ipsum')
StaticPage.create!(:name => 'payments', :human_name => 'Оплата', :text => 'Lorem Ipsum')
StaticPage.create!(:name => 'deliveries', :human_name => 'Доставка', :text => 'Lorem Ipsum')
StaticPage.create!(:name => 'contacts', :human_name => 'Контакты', :text => 'Lorem Ipsum')
StaticPage.create!(:name => 'delivery_block', :human_name => 'Блок текста в корзине', :text => 'Lorem Ipsum')