class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :middle_name, :last_name, :phone_number, :city, :address
  validates_presence_of :first_name, :last_name, :phone_number
  validates :phone_number, :format => { :with => /^[\+\d\ \(\)\-]{7,}$/ }
  has_many :shopping_carts
  has_many :addresses, :dependent => :restrict
  has_many :comments
  has_many :orders

  def self.auto_create user
    random_password = Digest::SHA1.hexdigest("#{Time.now.to_f}")[0,8]
    logger.debug user.inspect
    user[:password], user[:password_confirmation] = random_password, random_password
    user = self.new(user)
    Usermail.autoregistration(user, random_password).deliver if user.valid?
    user.save ? { :user => user } : { :user => nil, :validation_errors => user.errors }
  end

  def full_name
    [last_name, first_name, middle_name].join ' '
  end

  def self.valid_attribute?(attr, value)
    mock = self.new(attr => value)
    unless mock.valid?
      return !mock.errors.has_key?(attr)
    end
    true
  end

end
