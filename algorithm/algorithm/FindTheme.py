#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   FindTheme.py    
@Contact :   raogx.vip@hotmail.com
@License :   (C)Copyright 2017-2018, Liugroup-NLPR-CASIA

@Modify Time      @Author    @Version    @Desciption
------------      -------    --------    -----------
2019-01-08 11:10   yeweiyang      1.0         None
'''

# import lib
import Preprocess
import codecs
import TrainData
import jieba
from collections import Counter
from NaiveBayesian import NaiveBayesian
import numpy as np
from sklearn.externals import joblib
from sklearn.feature_extraction import DictVectorizer
import sys

def predict(idx):
    data, target = TrainData.load(idx)
    cls = NaiveBayesian()
    train_data = data[:-1]
    predict_data = data[-1]
    cls.fit(train_data, target)
    predicted = cls.predict(predict_data)
    return predicted


def predict_score(sub):
    save_price_path='../data/tags_'+sub+'_results'
    data, target = TrainData.load_model(save_price_path + '_tag','../model/'+sub+'_train_data.pkl')
#    train_data = data[:-1]
    predict_data = data[-1]
    model=joblib.load("../model_classifiers/model"+sub+"_LR.pkl")
    predicted = model.predict(predict_data)
    return predicted

def test_label(target, idx):
    label = []
    for index in range(len(target)):
        val = target[index]
        if str(val) == str(idx):
            label.append(str(1))
        else:
            label.append(str(0))
    return np.array(label)

def save_tokenlization_result(data, file_path='./data/tags_token_results'):
    with codecs.open(file_path, 'w', 'utf-8') as f:
        for x in data:
            f.write(' '.join(x) + '\n')


def getScore(input_word):
    data = []
    data.append(jieba.lcut(input_word))
    save_tokenlization_result(data,'./data/results')

    with codecs.open('./data/results', 'r', 'utf-8') as f:
        data = [line.strip().split() for line in f.read().split('\n')]
        print(type(data))
        if not data[-1]: data.pop()
        t = [Counter(d) for d in data]  # 每一行为一个短信， 值就是TF
        v = DictVectorizer()
        t = v.fit_transform(t)  # 稀疏矩阵表示sparse matrix,词编好号
        model=joblib.load("../model_classifiers/modelprice_LR.pkl")
        predict1 = model.predict(t)
        print(predict1)
        

if __name__ == '__main__':
    sub=['power', 'price', 'interior', 'configuration', 'safety', 'appearance', 'handling', 'fuel', 'space', 'comfort']
    data, target = Preprocess.read_train_data()
    for item in range(0, 10):
        label = test_label(target, item)
        Preprocess.save_tokenlization_result_target(label, item)

    #content = sys.argv[1]
    #content表示传递过来的评论内容
    #algorithm_type = sys.argv[2]
    #algorithm_type表示需要选用算法的id

    inputtxt = input("请输入你的评论：")
    data, target = Preprocess.read_train_data()
    inputtxt = inputtxt.strip()
    data.append(inputtxt)
    data = Preprocess.solve_data(data)
    Preprocess.save_tokenlization_result_data(data)
    Preprocess.vectword()

    res = []
    score=[]
    for item in range(0,10):
        res_data = predict(item)
        res.append(res_data)
        if res_data==1:
            d,t=Preprocess.read_data(sub[item])
            d.append(inputtxt)
            d=Preprocess.solve_data(d)
            Preprocess.save_tokenlization_result_data(data,'../data/tags_'+sub[item]+'_results')
            Preprocess.vectword_score('../data/tags_'+sub[item]+'_results','../model/'+sub[item]+'_train_data.pkl')
            score.append(predict_score(sub[item]))
        else:
            score.append(0)

        print(res)
        print(score)
        #只有一个数组的输出，这个数组的每个元素代表着一个主题的情感分析结果
        #输出格式为在控制台打印出每个主题的评分，分别是负向为-1，正向为1，中性为0，无此主题为2
        
        