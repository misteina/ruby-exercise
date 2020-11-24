class GroupEvent < ApplicationRecord

    validates :name, presence: true, length: { minimum: 50 }
    validates :location, length: { minimum: 50 }, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
    validates :description, length: { minimum: 200 }
    validates :start, format: { with: /^([0-9]{2,4})-([0-1][0-9])-([0-3][0-9])(?:( [0-2][0-9]):([0-5][0-9]):([0-5][0-9]))?$/, message: "Invalid event start date" }
    validates :end, format: { with: /^([0-9]{2,4})-([0-1][0-9])-([0-3][0-9])(?:( [0-2][0-9]):([0-5][0-9]):([0-5][0-9]))?$/, message: "Invalid event end date" }
    validates :duration, numericality: { only_integer: true, less_than: 365 }

end
