FROM elasticsearch:5.6.16

WORKDIR /usr/share/elasticsearch
RUN elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.6.16/elasticsearch-analysis-ik-5.6.16.zip
RUN elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v5.6.16/elasticsearch-analysis-pinyin-5.6.16.zip