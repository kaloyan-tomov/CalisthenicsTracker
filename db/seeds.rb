admin = User.find_or_initialize_by(email: "ktomov.dev@gmail.com")
admin.username = "Kaloyan"
admin.password = "SPYRALex67"
admin.password_confirmation = "SPYRALex67"
admin.role = :admin
admin.confirmed_at = Time.current
admin.save!

[
  "Push-up",
  "Pull-up",
  "Handstand",
  "Planche",
  "Front Lever",
  "Back Lever",
  "Muscle-up",
  "Dip"
].each do |name|
  Skill.find_or_create_by!(name: name)
end
