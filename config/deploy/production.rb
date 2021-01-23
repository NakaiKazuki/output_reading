server Rails.application.credentials.dig(:amazon, :ec2_ip),
       user: Rails.application.credentials.dig(:amazon, :ec2_user),
       roles: %w[web app db]

set :ssh_options, {
  keys: %w[~/.ssh/ec2_rsa],
  forward_agent: true
}

# eval `ssh-agent` && ssh-add ~/.ssh/git_rsa
