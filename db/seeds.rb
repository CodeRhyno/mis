# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  role: 'admin',
  active: true
)

puts "Created admin user: admin@example.com / password123"

# Create sample circles
circle1 = Circle.create!(name: "North Circle", code: "NC01", description: "North Region", active: true)
circle2 = Circle.create!(name: 'South Circle', code: 'SC01', description: 'Southern Region Circle', active: true)

puts "Created #{Circle.count} circles"

# Create sample branches
branch1 = Branch.create!(name: 'North Branch 1', code: 'NB01', circle: circle1, address: '123 North Street', active: true)
branch2 = Branch.create!(name: 'North Branch 2', code: 'NB02', circle: circle1, address: '456 North Avenue', active: true)
branch3 = Branch.create!(name: 'South Branch 1', code: 'SB01', circle: circle2, address: '789 South Road', active: true)

puts "Created #{Branch.count} branches"

# Create sample permissions
permission1 = Permission.create!(title: 'Read Documents', resource_type: 'Document', action: 'read')
permission2 = Permission.create!(title: 'Write Documents', resource_type: 'Document', action: 'write')
permission3 = Permission.create!(title: 'Delete Documents', resource_type: 'Document', action: 'delete')
permission4 = Permission.create!(title: 'Manage Users', resource_type: 'User', action: 'manage')

puts "Created #{Permission.count} permissions"

# Create sample users
circle_admin = User.create!(
  email: 'circle_admin@example.com',
  password: 'password123',
  first_name: 'Circle',
  last_name: 'Admin',
  role: 'circle_admin',
  circle: circle1,
  active: true
)

maker = User.create!(
  email: 'maker@example.com',
  password: 'password123',
  first_name: 'John',
  last_name: 'Maker',
  role: 'maker',
  circle: circle1,
  branch: branch1,
  active: true
)

checker = User.create!(
  email: 'checker@example.com',
  password: 'password123',
  first_name: 'Jane',
  last_name: 'Checker',
  role: 'checker',
  circle: circle1,
  branch: branch1,
  active: true
)

puts "Created #{User.count} users"
puts "
=================================
Setup complete!
Admin credentials:
Email: admin@example.com
Password: password123

Other test users:
- circle_admin@example.com / password123
- maker@example.com / password123
- checker@example.com / password123
================================="
