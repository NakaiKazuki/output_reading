server "52.193.175.43", user: "Kazuki", roles: %w{app db web}

set :ssh_options, {
  keys: %w(~/.ssh/Output-Reading_key_rsa),
  forward_agent: true
}
