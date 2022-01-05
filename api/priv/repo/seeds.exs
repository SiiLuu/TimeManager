# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Theme01.Repo.insert!(%Theme01.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Theme01.Repo
alias Theme01.Users.User

Repo.delete_all(User)
password = Bcrypt.add_hash("azerty")

Repo.insert!(%User{
  username: "generalmanager",
  email: "gm@test.fr",
  password_hash: password.password_hash,
  role: :GeneralManager
})

Repo.insert!(%User{
  username: "manager",
  email: "m@test.fr",
  password_hash: password.password_hash,
  role: :Manager
})

Repo.insert!(%User{
  username: "employee",
  email: "e@test.fr",
  password_hash: password.password_hash,
  role: :Employee
})
