# Terraform 実行方法

```
export TF_VAR_root_password=<新規サーバのrootユーザに設定するパスワード>
export TF_VAR_administrator_password=<新規サーバのadminユーザに設定するパスワード>
export TF_VAR_aws_access_key=<awsのアクセスキー>
export TF_VAR_aws_secret_key=<awsのシークレットキー>

terraform init
terraform apply
```

# Ansible 実行方法

```
export db_root_password=<dbのrootユーザに設定するパスワード>
export db_user_password=<dbのユーザに設定するパスワード>

ansible-playbook -i inventories/webserver.ini -u administrator --private-key=../ssh/ec2 -K webserver.yml
```
