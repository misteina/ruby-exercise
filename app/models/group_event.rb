class GroupEvent < ApplicationRecord

    validate :eventName, :eventLocation, :eventDescription, :startTime, :endTime, :eventDuration

    #validates :name, presence: true, length: { minimum: 2, maximum: 30 }
    #validates :location, length: { minimum: 3, maximum: 30 }, 
    #    format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" },
    #    if: :location?
    #validates :description, length: { minimum: 2, maximum: 200 }, if: :description?
    #validate :startTime, if: :eventstart?
    #validate :endTime, if: :eventend?
    #validates :start, format: { with: /\A([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0[0-9]|1[0-9]|2[1-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9]))\z/, message: "Invalid event start date" },
        #if: :start?
    #validates :end, format: { with: /\A([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0[0-9]|1[0-9]|2[1-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9]))\z/, message: "Invalid event end date" },
        #if: :end?
    #validates :duration, format: { with: /\A\d+\z/, message: "Invalid duration." }, if: :duration?
    
    def eventName
        if name.length < 2 || name.length > 30
            errors.add(:name, "Invalid event name")
        end
    end
    def eventLocation
        if location.present? && (location !~ /^[a-z]+$/i || location.length < 3 || location.length > 30)
            errors.add(:location, "Invalid event location")
        end
    end
    def eventDescription
        if description.present? && (description.length < 2 || description.length > 30)
            errors.add(:description, "Invalid event description")
        end
    end
    def startTime
        if eventstart.present?
            errors.add(:eventstart, 'Invalid event start date') if ((DateTime.parse(:eventstart) rescue ArgumentError) == ArgumentError)
        end
    end

    def endTime
        if eventend.present?
            errors.add(:eventend, 'Invalid event end date') if ((DateTime.parse(Leventend) rescue ArgumentError) == ArgumentError)
        end
    end
    def eventDuration
        if duration.present? && (duration < 1 || duration > 365)
            errors.add(:duration, "Invalid event duration")
        end
    end

end
