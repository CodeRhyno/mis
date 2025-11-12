class CreateInitialSchema < ActiveRecord::Migration[7.1]
  def change
    # Circles table
    create_table :circles do |t|
      t.string :name, null: false
      t.string :code
      t.text :description
      t.boolean :active, default: true
      t.timestamps
    end

    # Branches table
    create_table :branches do |t|
      t.references :circle, null: false, foreign_key: true
      t.string :name, null: false
      t.string :code
      t.text :address
      t.boolean :active, default: true
      t.timestamps
    end

    # Permissions table
    create_table :permissions do |t|
      t.string :title, null: false
      t.string :resource_type
      t.string :action
      t.text :description
      t.timestamps
    end

    # Users table
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.string :role, null: false, default: 'maker'
      t.references :circle, foreign_key: true
      t.references :branch, foreign_key: true
      t.boolean :active, default: true
      t.boolean :suspended, default: false
      t.datetime :last_login_at
      t.timestamps
    end

    add_index :users, :email, unique: true

    # User Permissions (Many-to-Many)
    create_table :user_permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.timestamps
    end

    add_index :user_permissions, [:user_id, :permission_id], unique: true

    # Records table
    create_table :records do |t|
      t.string :title, null: false
      t.text :description
      t.references :circle, foreign_key: true
      t.references :branch, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :verified_by, foreign_key: { to_table: :users }
      t.boolean :verified, default: false
      t.boolean :objected, default: false
      t.text :objection_reason
      t.datetime :verified_at
      t.timestamps
    end

    # Documents table (for record attachments)
    create_table :documents do |t|
      t.references :record, null: false, foreign_key: true
      t.string :filename, null: false
      t.string :file_path
      t.string :content_type
      t.integer :file_size
      t.string :sha256_hash, null: false
      t.references :uploaded_by, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :documents, :sha256_hash

    # Record Permissions
    create_table :record_permissions do |t|
      t.references :record, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.timestamps
    end
  end
end
