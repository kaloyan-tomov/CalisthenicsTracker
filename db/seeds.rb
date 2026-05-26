User.find_or_create_by!(email: "admin@example.com") do |u|
  u.username = "Admin"
  u.password = "admin1"
  u.password_confirmation = "admin1"
  u.role = :admin
  u.confirmed_at = Time.current
end

User.find_or_create_by!(email: "pederakis@manafakis.com") do |u|
  u.username = "Pederakis Manafakis"
  u.password = "SPYRALex67"
  u.password_confirmation = "SPYRALex67"
  u.role = :trainee
  u.confirmed_at = Time.current
end

User.find_or_create_by!(email: "maria@example.com") do |u|
  u.username = "Maria"
  u.password = "password"
  u.password_confirmation = "password"
  u.role = :trainee
  u.confirmed_at = Time.current
end

skills = [
  "Push-up",
  "Pull-up",
  "Handstand",
  "Planche",
  "Front Lever",
  "Back Lever",
  "Muscle-up",
  "Dip"
]

skills.each do |name|
  Skill.find_or_create_by!(name: name)
end
