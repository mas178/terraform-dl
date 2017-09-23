# Kaggle用環境構築スクリプト

- GPUでKaggleするための環境構築スクリプト
- ベースとなるAMIは [Deep Learning AMI Ubuntu Version](https://aws.amazon.com/marketplace/pp/B06VSPXKDX)

### 前提条件

- IAM作成済み (Access key と Secret access key がわかっていること)
- キーペア作成済み (*.pemファイルをダウンロードしていること)

### 環境構築手順

```
git clone XXX
cd XXX
cp sample_terraform.tfvars terraform.tfvars
vi terraform.tfvars # aws_access_key, aws_secret_key, ssh_key_file, github_password を記載する
terraform apply
```

### よく使うコマンド

##### terraform

```
# 環境を構築する
terraform apply

# 環境を確認する
terraform show
terraform show | grep public_dns

# 環境を破棄する
terraform destroy
```

##### SSHでログイン
```
ssh -i "~/.ssh/dl.pem" ubuntu@ec2-54-92-70-120.ap-northeast-1.compute.amazonaws.com
```

##### jupyter notebook

```
jupyter notebook --ip=0.0.0.0
```

##### データ分析実行
```
cd ~/Kaggle-Carvana-Image-Masking-Challenge
vi params.py
nohup python3 train.py && python3 test_submit.py kg submit submit/submission.csv.gz &
```
