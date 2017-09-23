# Terraform Script to make playground for Deep Learning with GPU on AWS

- Based on [Deep Learning AMI Ubuntu Version](https://aws.amazon.com/marketplace/pp/B06VSPXKDX)
- Please use this script at your own risk

### Prerequisite

- IAM (Access key and Secret access key)
- Key pair (download *.pem file)

### Procedure

```
git clone https://github.com/mas178/terraform-dl.git
cd https://github.com/mas178/terraform-dl.git
cp sample_terraform.tfvars terraform.tfvars
vi terraform.tfvars # aws_access_key, aws_secret_key, ssh_key_file, github_password を記載する
terraform apply
```

### Frequent used commands

##### terraform

```
# make environment
terraform apply

# confirm current situation
terraform show
terraform show | grep public_dns

# destroy environment
terraform destroy
```

##### Login via SSH
```
ssh -i "~/.ssh/dl.pem" ubuntu@ec2-99-99-999-999.ap-northeast-1.compute.amazonaws.com
```

##### jupyter notebook

```
jupyter notebook --ip=0.0.0.0
```

##### Run data analysis

```
cd ~/Kaggle-Carvana-Image-Masking-Challenge
vi params.py
nohup python3 train.py && python3 test_submit.py kg submit submit/submission.csv.gz &
```
