# 概要
TerraformとAnsibleを用いたEC-CUBEのデプロイ自動化です。  
AWS上に簡単デプロイすることができます。  

## 対象
### EC-CUBEバージョン
- 4.0.0 - 4.2.2  

### IaaS環境
- AWS
- GoogleCloudなども対応予定

# 使い方
以下の順番にて設定を行って下さい。
1. Docker上に設定環境の構築
2. Terraformによるインフラ設定
3. Ansibleによるアプリケーション設定

## Docker上に設定環境の構築
```
docker compose -f docker-compose.yml up -d
```
設定環境起動後は以下でコンテナ内に入ります。
```
docker exec -it infra bash
```
設定環境内にて環境変数を設定します。
```
export TF_VAR_root_password=<新規サーバのrootユーザに設定するパスワード>
export TF_VAR_administrator_password=<新規サーバのadminユーザに設定するパスワード>
export TF_VAR_aws_access_key=<awsのアクセスキー>
export TF_VAR_aws_secret_key=<awsのシークレットキー>
export db_root_password=<dbのrootユーザに設定するパスワード>
export db_user_password=<dbのユーザに設定するパスワード>
```

## Terraformによるインフラ設定

以下の操作にてIaaS上にサーバをデプロイします。
```
cd terraform-aws/
terraform init
terraform apply
```

尚、AWS上のリソース設定は以下で行います。
```
terraform-aws/variables.tf
```
| 項目 | 内容|
| -- | -- |
| ec2_ami | ec2のami |
| ec2_instance_type | ec2のリソース |
| ebs_root_volume_type | ルートボリュームタイプ |
| ebs_root_volume_size | ルートボリュームサイズ |

## Ansibleによるアプリケーション設定

以下の操作にてデプロイしたサーバ上にアプリケーション設定を行います。
```
cd ansible/
ansible-playbook -i inventories/webserver.ini -u administrator --private-key=../ssh/ec2 -K webserver.yml
```

尚、EC-CUBEにて使用するミドルウェアの指定は以下で行います。
```
ansible/config.yml
```
