# -*- coding: utf-8 -*-
"""
Created on Wed Jan  9 01:27:51 2019

@author: WangWenming
"""

from collections import Counter
from multiprocessing.pool import Pool
import jieba
import codecs
import csv

from sklearn.feature_extraction import DictVectorizer
from model_manage import TrainData


def read_train_data(subject):
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
   csv_reader = csv.reader(open('./data/train.csv', encoding='utf-8'))
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


def save_tokenlization_result(data, target, file_path='./data/tags_token_results'):
    with codecs.open(file_path, 'w', 'utf-8') as f:
        for x in data:
            f.write(' '.join(x) + '\n')

    with open(file_path + '_tag', 'w') as f:
        for x in target:
            f.write(x + '\n')


if __name__ == '__main__':
    
    # seg_list = jieba.cut("我来到北京清华大学", cut_all=False)
    # print("Default Mode: " + "/ ".join(seg_list))  # 精确模式
    data_sub=['power', 'price', 'interior', 'configuration', 'safety', 'appearance', 'handling', 'fuel', 'space', 'comfort']
    for i in range(10):
        sub=data_sub[i]
        txtdata, target = read_train_data(sub)
        #data = Pool().map(jieba.lcut, txtdata)
        # data = jieba.lcut(data)
        data = []
        for item_txt in txtdata:
            data.append(jieba.lcut(item_txt))
        save_tokenlization_result(data, target,'./data/tags_'+sub+'_results')
    
        with codecs.open('./data/tags_'+sub+'_results', 'r', 'utf-8') as f:
            data = [line.strip().split() for line in f.read().split('\n')]
            print(type(data))
            if not data[-1]: data.pop()
            t = [Counter(d) for d in data]  # 每一行为一个短信， 值就是TF
            v = DictVectorizer()
            t = v.fit_transform(t)  # 稀疏矩阵表示sparse matrix,词编好号
            TrainData.save(t,'./model/'+sub+'_train_data.pkl')
