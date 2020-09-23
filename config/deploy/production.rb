server "www.output-reading.xyz", user: "Kazuki", roles: %w{app db web}

set :ssh_options, {
  keys: %w(~/.ssh/Output-Reading_key_rsa),
  forward_agent: true
}
