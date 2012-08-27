class Event < ActiveRecord::Base
  attr_accessible :active, :description, :name, :place, :start_datetime, :user_id
end
