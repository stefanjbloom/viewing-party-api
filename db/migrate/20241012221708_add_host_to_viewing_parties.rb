class AddHostToViewingParties < ActiveRecord::Migration[7.1]
  def change
    add_reference :viewing_parties, :host, null: false, foreign_key: { to_table: :users}
  end
end
