# nvidiaのpytorchを使用する
FROM nvcr.io/nvidia/pytorch:21.08-py3

RUN apt-get update  && \
    apt-get upgrade -y && \
    apt-get install -y --reinstall build-essential && \
    apt-get install -y sudo && \
    apt-get install -y vim  && \
    apt-get install -y git && \
    apt-get install -y curl && \
    apt-get install -y zip unzip &&\
    apt-get install -y file && \
    apt-get install -y wget && \
    ## mecab関連インストール
    apt-get install -y mecab && \
    apt-get install -y libmecab-dev && \
    apt-get install -y mecab-ipadic-utf8 && \
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    bin/install-mecab-ipadic-neologd -n -y -a && \
    rm -rf /home/jovyan/mecab-ipadic-neologd && \
    # imageのサイズを小さくするためにキャッシュ削除
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # pipのアップデート
    pip install --upgrade pip


# 作業するディレクトリを変更
WORKDIR /home/

COPY requirements.txt ${PWD}

# pythonのパッケージをインストール
RUN pip install -r requirements.txt

# pytorchのバージョン指定
RUN pip3 install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html

# mecabrcをコピー
RUN cp /etc/mecabrc /usr/local/etc/mecabrc

# 作業するディレクトリを変更
# コンテナの内部には入った際のディレクトリの位置を変更している
#WORKDIR /home/workspase/src
