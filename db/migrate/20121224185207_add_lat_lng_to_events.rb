class AddLatLngToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lat, :decimal, {:precision => 10, :scale => 6}
    add_column :events, :lng, :decimal, {:precision => 10, :scale => 6}
  end
end
