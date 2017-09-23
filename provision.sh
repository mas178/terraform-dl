#!/bin/bash
echo '--------------------'
echo 'Set tensorflow as Keras backend'
echo '--------------------'
/bin/mkdir ~/.keras
echo '{"image_dim_ordering": "tf", "floatx": "float32", "backend": "tensorflow", "epsilon": 1e-07}' > ~/.keras/keras.json

echo '--------------------'
echo 'Import source code'
echo '--------------------'
git clone https://github.com/mas178/Kaggle-Carvana-Image-Masking-Challenge.git

echo '--------------------'
echo 'Install libraries'
echo '--------------------'
python3 --version
pip3 --version
cd Kaggle-Carvana-Image-Masking-Challenge
sudo pip3 install -r requirements.txt
sudo pip3 install kaggle-cli
sudo pip3 list --outdated --format=legacy | awk '{print $1}' | xargs sudo pip3 install -U
sudo pip3 check

echo '--------------------'
echo 'Install exiftool'
echo '--------------------'
cd ~
wget https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.61.tar.gz
tar -xf Image-ExifTool-10.61.tar.gz
rm Image-ExifTool-10.61.tar.gz

echo '--------------------'
echo 'Mount additional volume'
echo '--------------------'
sudo mkfs -t ext4 /dev/xvdh
sudo mount /dev/xvdh ~/Kaggle-Carvana-Image-Masking-Challenge/input
sudo chown ubuntu:ubuntu ~/Kaggle-Carvana-Image-Masking-Challenge/input
df -h

echo '--------------------'
echo 'Prepare data'
echo '--------------------'
kg config -u minaba -p $1 -c carvana-image-masking-challenge
cd ~/Kaggle-Carvana-Image-Masking-Challenge/input/
nohup sh -c 'kg download -f sample_submission.csv.zip && unzip -q sample_submission.csv.zip && rm sample_submission.csv.zip' &
nohup sh -c 'kg download -f train_masks.csv.zip       && unzip -q train_masks.csv.zip       && rm train_masks.csv.zip' &
nohup sh -c 'kg download -f train_masks.zip           && unzip -q train_masks.zip           && rm train_masks.zip && cd train_masks/ && mogrify -format png *.gif && rm *.gif && ~/Image-ExifTool-10.61/exiftool -overwrite_original -all= *' &
nohup sh -c 'kg download -f train.zip                 && unzip -q train.zip                 && rm train.zip' &
nohup sh -c 'kg download -f test.zip                  && unzip -q test.zip                  && rm test.zip' &
nohup sh -c 'kg download -f train_hq.zip              && unzip -q train_hq.zip              && rm train_hq.zip' &
nohup sh -c 'kg download -f test_hq.zip               && unzip -q test_hq.zip               && rm test_hq.zip' &
sleep 5
