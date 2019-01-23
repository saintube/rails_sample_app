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
import sys 
import os
from sklearn.externals import joblib
from sklearn.feature_extraction import DictVectorizer

last_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
dir_path = os.path.dirname(os.path.abspath(__file__))

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

def train_NBmodel(train_data,target):
    model = NaiveBayesian()
    model.fit(train_data, target)
    TrainData.save(model,last_path+"/model_classifiers/model_NB.pkl")
    return model

def predict():
    data, target = TrainData.load()
    train_data = data[:-1]
    predict_data = data[-1]
    try:
        model=joblib.load(last_path+"/model_classifiers/model_NB.pkl")
        predicted = model.predict(predict_data)
    except:
        model=train_NBmodel(train_data,target)
        predicted = model.predict(predict_data)
    return predicted

def predict_score(sub,m):
    save_price_path=last_path+'/data/tags_'+sub+'_results'
    data, target = TrainData.load_model(save_price_path + '_tag',last_path+'/model/'+sub+'_train_data.pkl')
    train_data = data[:-1]
    predict_data = data[-1]
    try:
        model=joblib.load(last_path+"/model_classifiers/model"+sub+"_LR.pkl")
        predicted = model.predict(predict_data)
    except:
        if m=='KNN':
            model=knn_classifier(train_data,target)
        elif m=='LR':
            model=logistic_regression_classifier(train_data,target)
        elif m=='RF':
            model=random_forest_classifier(train_data,target)
        elif m=='DT':
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
    Preprocess.save_tokenlization_result_target(target)
    classifiers = ['KNN','LR','RF','DT','GBDT']
    inputtxt = inputtxt.strip()
    data.append(inputtxt)
    data = Preprocess.solve_data(data)
    Preprocess.save_tokenlization_result_data(data)
    Preprocess.vectword()
    score=[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    res_data = predict()
    idx = res_data[0]
    d,t=Preprocess.read_data(sub[idx])
    d.append(inputtxt)
    d=Preprocess.solve_data(d)
    Preprocess.save_tokenlization_result_data(data,last_path+'/data/tags_'+sub[idx]+'_results')
    Preprocess.vectword_score(last_path+'/data/tags_'+sub[idx]+'_results',last_path+'/model/'+sub[idx]+'_train_data.pkl')
    final_data = predict_score(sub[idx],classifiers[m])
    score[idx] = final_data
    for item in score:
        print(item)
    

def test_label(target, idx):
    label = []
    for index in range(len(target)):
        val = target[index]
        if str(val) == str(idx):
            label.append(str(1))
        else:
            label.append(str(0))
    return np.array(label)

def save_tokenlization_result(data, file_path=dir_path+'/data/tags_token_results'):
    with codecs.open(file_path, 'w', 'utf-8') as f:
        for x in data:
            f.write(' '.join(x) + '\n')

def getScore(input_word):
    data = []
    data.append(jieba.lcut(input_word))
    save_tokenlization_result(data,dir_path+'/data/results')

    with codecs.open(dir_path+'/data/results', 'r', 'utf-8') as f:
        data = [line.strip().split() for line in f.read().split('\n')]
        print(type(data))
        if not data[-1]: data.pop()
        t = [Counter(d) for d in data]  # 每一行为一个短信， 值就是TF
        v = DictVectorizer()
        t = v.fit_transform(t)  # 稀疏矩阵表示sparse matrix,词编好号
        model=joblib.load(last_path+"/model_classifiers/modelprice_LR.pkl")
        predict1 = model.predict(t)
        print(predict1)

if __name__ == '__main__':
    inputtxt = sys.argv[1]
    algorithm_type = sys.argv[2]
    algorithm_type= int(algorithm_type)
    appInterface(inputtxt, algorithm_type)
    

