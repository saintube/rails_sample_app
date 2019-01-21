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
import os
import csv
import TrainData
from collections import Counter
from sklearn.feature_extraction import DictVectorizer


dir_path = os.path.dirname(os.path.abspath(__file__))

def read_data(subject):
   if subject=='price':
       subject='价格'
   elif subject=='setting':
       subject='配置'
   elif subject=='interior':
       subject='内饰'
   elif subject=='power':
       subject='动力'
   elif subject=='comfort':
       subject='舒适性'
   elif subject=='safety':
       subject='安全性'
   elif subject=='appearance':
       subject='外观'
   elif subject=='handling':
       subject='操控'
   elif subject=='fuel':
       subject='油耗'
   elif subject=='space':
       subject='空间'
   data=[]
   target=[]
   csv_reader = csv.reader(open(dir_path+'/data/train.csv', encoding='utf-8'))
   for row in csv_reader:
       if row[2]=='价格':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='配置':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='内饰':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='动力':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='舒适性':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='安全性':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='外观':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='操控':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='油耗':
           data.append(row[1])
           target.append(row[3])
       elif row[2]=='空间':
           data.append(row[1])
           target.append(row[3])
   return data, target

def read_train_data():
    """
    1.函数读入输入数据.txt文件
    :return:评论主题和label标签
    """
    input_file = dir_path+"/data/train_data.txt"
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

def save_tokenlization_result_data(data, file_path=dir_path+"/data/tags_token_results"):
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

def save_tokenlization_result_target(target, idx, file_path=dir_path+"/data/tags_token_results"):
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
    with codecs.open(dir_path+"/data/tags_token_results", 'r', 'utf-8') as f:
        data = [line.strip().split() for line in f.read().split('\n')]
        if not data[-1]:
            data.pop()
        # 每一行为一个短信，值就是TF
        t = [Counter(d) for d in data]
        v = DictVectorizer()
        # 稀疏矩阵表示sparse matrix,词编好号
        t = v.fit_transform(t)
        TrainData.save(t)
def vectword_score(filename,file_save):
    with codecs.open(filename, 'r', 'utf-8') as f:
        data = [line.strip().split() for line in f.read().split('\n')]
        if not data[-1]:
            data.pop()
        # 每一行为一个短信，值就是TF
        t = [Counter(d) for d in data]
        v = DictVectorizer()
        # 稀疏矩阵表示sparse matrix,词编好号
        t = v.fit_transform(t)
        TrainData.save(t,file_save)
