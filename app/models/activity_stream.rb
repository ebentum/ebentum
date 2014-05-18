class ActivityStream < CouchRest::Model::Base
  use_database 'activity_streams'

  design do
    view :stream,
      :map =>
        "function(doc) {
          var new_values = [];
          for(var i = 0; i < doc.value.length; i++) {
            new_values = new_values.concat([[doc.value[i][1], doc.value[i][2], doc.value[i][3]]]);
          }
          emit([doc.key[0], doc.value[0][0], doc.key[1]], new_values);
        }"
  end



  def self.user_activity_stream(receiver, startDate = nil)

    event_ids = []
    receiver_ids = []
    user_ids = []
    activity_stream = []

    event_list = {}
    user_list = {}
    receiver_list = {}

    if !startDate.nil?
      startkey = [receiver._id, startDate+"0"]
    else
      startkey = [receiver._id]
    end

    #Generate activity_stream with user/events indexes
    ActivityStream.stream
      .startkey(startkey)
      .endkey([receiver._id, {}])
      .limit(Kaminari.config.default_per_page)
      .descending
    .rows.each_with_index do |activity, activity_index|

      if activity.key[2] == "Event"
        event_ids << activity.key[3]

        activity_stream[activity_index] = {
          :event => activity.key[3],
          :date => activity.key[1],
          :actions => []
        }
      elsif activity.key[2] == "User"
        user_ids << activity.key[3]

        activity_stream[activity_index] = {
          :user => activity.key[3],
          :date => activity.key[1],
          :actions => []
        }
      end

      activity.value.each_with_index do |action, action_index|
        receiver_index = receiver_ids.index(action[1])
        if receiver_index.nil?
          receiver_ids << action[1]
          receiver_index = receiver_ids.count - 1
        end
        activity_stream[activity_index][:actions][action_index] = {
            :verb => action[2],
            :receiver => action[1],
            :date => action[0]
        }
      end

    end

    #find distinct events/users data
    if !event_ids.empty?
      events = Event.find(event_ids)

      events.each_with_index do |event, index|
        event_list[""+event.id] = index
      end
    end

    if !user_ids.empty?
      users = User.find(user_ids)

      users.each_with_index do |user, index|
        user_list[""+user.id] = index
      end
    end

    if !receiver_ids.empty?
      receivers = User.find(receiver_ids)

      receivers.each_with_index do |receiver, index|
        receiver_list[""+receiver.id] = index
      end
    end

    #replace the indexes with data
    activity_stream.each do |activity|
      if !activity[:event].nil?
        if event_list.include?(activity[:event])
          activity[:event] = events[event_list[activity[:event]]]
        else
          activity[:event] = nil
        end
      elsif !activity[:user].nil?
        activity[:user] = users[user_list[activity[:user]]]
      end

      activity[:actions].each do |action|
        if !action[:receiver].nil?
          if receiver_list.include?(action[:receiver])
            action[:receiver] = receivers[receiver_list[action[:receiver]]]
          else
            action[:receiver] = nil
          end
        end
      end

    end

    activity_stream

  end

end