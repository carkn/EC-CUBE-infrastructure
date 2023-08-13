variable root_password {
  sensitive = true
  description = "新規サーバのrootユーザに設定するパスワード"
}

variable administrator_password {
  sensitive = true
  description = "新規サーバのadminユーザに設定するパスワード"
}

variable aws_access_key {
  sensitive = true
  description = "awsのアクセスキー"
}

variable aws_secret_key {
  sensitive = true
  description = "awsのアクセスキー"
}

variable ec2_ami {
  default = "ami-0ed99df77a82560e6" # Ubuntu 20.04 LTS
  description = "ec2のイメージ"
}

variable ec2_instance_type {
  default = "t2.micro"
  description = "ec2のリソース"
}

variable ebs_root_volume_type {
  default = "gp2"
  description = "ec2のrootボリュームタイプ"
}

variable ebs_root_volume_size {
  default = "10"
  description = "ec2のrootボリュームサイズ"
}

variable ebs_root_delete_on_termination {
  default = "true"
  description = "terraformでの削除フラグ"
}
