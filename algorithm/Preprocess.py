#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   Preprocess.py
@Contact :   raogx.vip@hotmail.com
@License :   (C)Copyright 2017-2018, Liugroup-NLPR-CASIA

@Modify Time      @Author    @Version    @Desciption
------------      -------    --------    -----------
2019-01-08 11:39   yeweiyang      1.0         None
'''

# import lib
import jieba
import codecs
import TrainData
from collections import Counter
from sklearn.feature_extraction import DictVectorizer


def read_train_data():
    """
    1.函数读入输入数据.txt文件
    :return:评论主题和label标签
    """
    input_file = "./data/train_data.txt"
    target = []
    data = []
    with codecs.open(input_file, "r", "utf-8") as f:
        for line in f.read().split('\n')[:-1]:
            line = line.strip()
            target.append(line[0])
            data.append(line[1:].lstrip())
    return data,target

def solve_data(txtdata):
    """
    2.对提取的数据进行jieba分词
    :param txtdata:文本数据
    :return:
    """
    data = []
    for item_txt in txtdata:
        data.append(jieba.lcut(item_txt))
    return data

def save_tokenlization_result_data(data, file_path="./data/tags_token_results"):
    """
    3.对提取的data数据进行序列化保存
    :param data:
    :param target:
    :param file_path:
    :return:
    """
    with codecs.open(file_path, 'w', 'utf-8') as f:
        for x in data:
            f.write(' '.join(x) + '\n')

def save_tokenlization_result_target(target, idx, file_path="./data/tags_token_results"):
    """
    3.对提取的target数据进行序列化保存
    :param target:
    :param file_path:
    :return:
    """
    with open(file_path+'_tag'+str(idx), 'w') as f:
        for x in target:
            f.write(x + '\n')

def vectword():
    """
    4.对文本序列化数据建立词向量矩阵
    :return:
    """
    with codecs.open('./data/tags_token_results', 'r', 'utf-8') as f:
        data = [line.strip().split() for line in f.read().split('\n')]
        if not data[-1]:
            data.pop()
        # 每一行为一个短信，值就是TF
        t = [Counter(d) for d in data]
        v = DictVectorizer()
        # 稀疏矩阵表示sparse matrix,词编好号
        t = v.fit_transform(t)
        TrainData.save(t)
