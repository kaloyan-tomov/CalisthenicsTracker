User.find_or_create_by!(email: "ktomov.dev@gmail.com") do |u|
  u.username = "Kaloyan"
  u.password = "SPYRALex67"
  u.password_confirmation = "SPYRALex67"
  u.role = :admin
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
