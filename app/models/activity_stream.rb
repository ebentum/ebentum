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

    event_activities_num = 0
    user_activities_num = 0

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
          :event => activity_index,
          :date => activity.key[1],
          :actions => []
        }
      elsif activity.key[2] == "User"
        user_ids << activity.key[3]

        activity_stream[activity_index] = {
          :user => activity_index,
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
            :receiver => receiver_index,
            :date => action[0]
        }
      end

    end

    #find distinct events/users data
    if !event_ids.empty?
      events = Event.find(event_ids)
    end

    if !user_ids.empty?
      users = User.find(user_ids)
    end

    if !receiver_ids.empty?
      receivers = User.find(receiver_ids)
    end

    #replace the indexes with data
    activity_stream.each do |activity|
      if !activity[:event].nil?
        activity[:event] = events[event_activities_num]
        event_activities_num = event_activities_num + 1
      elsif !activity[:user].nil?
        activity[:user] = users[user_activities_num]
        user_activities_num = user_activities_num + 1
      end

      activity[:actions].each do |action|
        action[:receiver] = receivers[action[:receiver]]
      end

    end

    activity_stream

  end

end