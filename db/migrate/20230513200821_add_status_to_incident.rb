class AddStatusToIncident < ActiveRecord::Migration[6.0]
  def change
    add_column :incidents, :status, :string
  end
end
