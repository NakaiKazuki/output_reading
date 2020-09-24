server "54.199.59.49", user: "Kazuki", roles: %w{app db web}

set :ssh_options, {
  keys: %w(~/.ssh/Output-Reading_key_rsa),
  forward_agent: true
}
