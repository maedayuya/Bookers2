class AddCoulmnToSearchHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :search_histories, :search, :string
    add_column :search_histories, :user_id, :integer
  end
end
