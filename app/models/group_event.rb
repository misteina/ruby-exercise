class GroupEvent < ApplicationRecord

=begin
    validates :name, present: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" },
        length: { minimum: 2, maximum: 30 }, if: :name?
    validates :location, length: { minimum: 3, maximum: 30 }, 
        format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" },
        if: :location?
    validates :description, length: { minimum: 2, maximum: 200 }, if: :description?
    validates :eventstart, format: { with: /\A([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0[0-9]|1[0-9]|2[1-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9]))\z/, message: "Invalid event start date" },
        if: :eventstart?
    validates :eventend, format: { with: /\A([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0[0-9]|1[0-9]|2[1-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9]))\z/, message: "Invalid event end date" },
        if: :eventend?
    validates :duration, format: { with: /\A[0-9]+\z/, message: "Invalid group event duration." }, if: :duration?
=end

    validate :eventName, :eventLocation, :eventDescription, :eventStartTime, :eventEndTime, :eventDuration 

    def eventName
        if !name.present? || name.length < 3 || name.length > 30 || name !~ /\A[a-zA-Z0-9\-\+%.]+\z/
            errors.add(:name, ":Group event name is required should and be valid")
        end
    end

    def eventLocation
        if location.present? && (location.length < 3 || location.length > 30 || location !~ /\A[a-zA-Z]+\z/)
            errors.add(:location, ":Invalid group event location")
        end
    end

    def eventDescription
        if description.present? && (description.length < 2 || description.length > 200)
            errors.add(:description, ":Invalid group event description")
        end
    end

    def eventStartTime
        if eventstart.present? && eventstart.to_s.chomp(" UTC") !~ /\A([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0[0-9]|1[0-9]|2[1-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9]))\z/
            errors.add(:eventstart, ":Invalid event start time")
        end
    end

    def eventEndTime
        if eventend.present? && eventend.to_s.chomp(" UTC") !~ /\A([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0[0-9]|1[0-9]|2[1-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9]))\z/
            errors.add(:eventend, ":Invalid event end time")
        end
    end

    def eventDuration
        if duration.present? && duration.to_s !~ /\A[0-9]+\z/
            errors.add(:duration, ":Invalid event duration")
        end
    end
    
end
