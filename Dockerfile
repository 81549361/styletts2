FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

RUN pip install --upgrade pip
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    vim \
    espeak-ng \
    build-essential \
    unzip \
    net-tools \
    && rm -rf /var/lib/apt/lists/*
# 确保 NLTK 数据目录存在
RUN mkdir -p /usr/share/nltk_data/tokenizers
#RUN apt-get update
#RUN apt-get install -y unzip
RUN ls
# 设置工作目录
WORKDIR /app
RUN ls
# 解压punkt数据包到 NLTK 数据目录
COPY punkt.zip /tmp/punkt.zip
RUN unzip /tmp/punkt.zip -d /usr/share/nltk_data/tokenizers
# 克隆StyleTTS2仓库
COPY StyleTTS2 /app/styletts

# 进入克隆的仓库目录
WORKDIR /app/styletts

# 安装Python依赖
RUN pip install -r requirements.txt

# 创建模型存放目录
RUN mkdir -p Utils/MODELS
#RUN [ "python3", "-c", "import nltk; nltk.download('punkt')" ]
#RUN wget https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip

RUN netstat -topln
# 清理下载的zip文件
RUN rm /tmp/punkt.zip

# 设置环境变量，以确保 NLTK 知道在哪里找到数据
ENV NLTK_DATA /usr/share/nltk_data
# 下载模型文件
RUN wget -O Utils/MODELS/chpt.pth "https://huggingface.co/taozi555/style_eng/resolve/main/epoch_2nd_00007.pth?download=true"
RUN wget -O Utils/MODELS/config.yml "https://huggingface.co/taozi555/style_eng/resolve/main/config.yml?download=true"
# 暴露5000端口
EXPOSE 5000

CMD ["python", "api.py"]