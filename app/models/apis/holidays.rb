module APIS
  class Holidays

    def initialize(response_body)
      @response_body = response_body
    end

    def all_holidays_in_upcoming_order
      grouping = Hash.new(0)
      @response_body.each do |holiday|
        if !holiday['name'].nil?
          grouping[holiday['localName']] = holiday['date']
        end
      end
      grouping
    end

  end
end
