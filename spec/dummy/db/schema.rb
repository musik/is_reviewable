ActiveRecord::Schema.define(:version => 20110727184726) do

  create_table :reviews, force: true do |t|
    t.references  :reviewable,    :polymorphic => true

    t.references  :reviewer,      :polymorphic => true
    t.string      :ip,            :limit => 24

    t.float       :rating
    t.text        :body

    #
    # Custom fields goes here...
    #
    # t.string      :title
    # t.string      :mood
    # ...
    #

    t.timestamps
  end

  add_index :reviews, :reviewer_id
  add_index :reviews, :reviewer_type
  add_index :reviews, [:reviewer_id, :reviewer_type]
  add_index :reviews, [:reviewable_id, :reviewable_type]

  create_table :products, force: true do |t|
    t.string      :name
  end

  create_table :users, force: true do |t|
    t.string      :name
  end

end