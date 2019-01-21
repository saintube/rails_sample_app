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

# Logistic Regression Classifier  
def logistic_regression_classifier(train_x, train_y):  
    from sklearn.linear_model import LogisticRegression  
    model = LogisticRegression(penalty='l2')  
    model.fit(train_x, train_y)  
    return model  

# KNN Classifier  
def knn_classifier(train_x, train_y):  
    from sklearn.neighbors import KNeighborsClassifier  
    model = KNeighborsClassifier()  
    model.fit(train_x, train_y)  
    return model  

# Random Forest Classifier  
def random_forest_classifier(train_x, train_y):  
    from sklearn.ensemble import RandomForestClassifier  
    model = RandomForestClassifier(n_estimators=8)  
    model.fit(train_x, train_y)  
    return model  

# GBDT(Gradient Boosting Decision Tree) Classifier  
def gradient_boosting_classifier(train_x, train_y):  
    from sklearn.ensemble import GradientBoostingClassifier  
    model = GradientBoostingClassifier(n_estimators=200)  
    model.fit(train_x, train_y)  
    return model  

# Decision Tree Classifier  
def decision_tree_classifier(train_x, train_y):  
    from sklearn import tree  
    model = tree.DecisionTreeClassifier()  
    model.fit(train_x, train_y)  
    return model 


def predict(idx):
    data, target = TrainData.load(idx)
    cls = NaiveBayesian()
    train_data = data[:-1]
    predict_data = data[-1]
    cls.fit(train_data, target)
    predicted = cls.predict(predict_data)
    return predicted


def predict_score(sub,model):
    save_price_path='../data/tags_'+sub+'_results'
    data, target = TrainData.load_model(save_price_path + '_tag','../model/'+sub+'_train_data.pkl')
    train_data = data[:-1]
    predict_data = data[-1]
    if model=='KNN':
        model=knn_classifier(train_data,target)
    elif model=='LR':
        model=logistic_regression_classifier(train_data,target)
    elif model=='RF':
        model=random_forest_classifier(train_data,target)
    elif model=='DT':
        model=decision_tree_classifier(train_data,target)
    else:
        model=gradient_boosting_classifier(train_data,target)
    predicted = model.predict(predict_data)
    return predicted[0]+1
    

    
    
#接口，供ruby调用，返回数组
#输出格式为在控制台打印出每个主题的评分，分别是负向为-1，正向为1，中性为0，无此主题为2
def appInterface(inputtxt,m):
    sub=['power', 'price', 'interior', 'configuration', 'safety', 'appearance', 'handling', 'fuel', 'space', 'comfort']
    data, target = Preprocess.read_train_data()
    for item in range(0, 10):
        label = test_label(target, item)
        Preprocess.save_tokenlization_result_target(label, item)
    classifiers = ['KNN','LR','RF','DT','GBDT']
    data, target = Preprocess.read_train_data()
    inputtxt = inputtxt.strip()
    data.append(inputtxt)
    data = Preprocess.solve_data(data)
    Preprocess.save_tokenlization_result_data(data)
    Preprocess.vectword()
    score=[]
    for item in range(0,10):
        res_data = predict(item)
        if res_data==1:
            d,t=Preprocess.read_data(sub[item])
            d.append(inputtxt)
            d=Preprocess.solve_data(d)
            Preprocess.save_tokenlization_result_data(data,'../data/tags_'+sub[item]+'_results')
            Preprocess.vectword_score('../data/tags_'+sub[item]+'_results','../model/'+sub[item]+'_train_data.pkl')
            score.append(predict_score(sub[item],classifiers[m]))
        else:
            score.append(-1)
    print(score)
    

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
    #inputtxt = input("请输入你的评论:")
    
    appInterface(inputtxt,1)

