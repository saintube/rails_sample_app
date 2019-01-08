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
import TrainData
from NaiveBayesian import NaiveBayesian
import numpy as np
from sklearn.externals import joblib

def predict(idx):
    data, target = TrainData.load(idx)
    print(target)
    cls = NaiveBayesian()
    train_data = data[:-1]
    predict_data = data[-1]
    cls.fit(train_data, target)
    predicted = cls.predict(predict_data)
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

# def test_train():
#     data, target = Preprocess.read_train_data()
#     data = Preprocess.solve_data(data)
#     Preprocess.save_tokenlization_result(data, target)
#     Preprocess.vectword()
#     data, target = TrainData.load()
#     cls = NaiveBayesian()
#     cls = cls.fit(data, target)
#     joblib.dump(cls, './model/NaiveBayesian.pkl')

# def test_predict(inputtxt):
#     data, target = Preprocess.read_train_data()
#     inputtxt = inputtxt.strip()
#     data.append(inputtxt)
#     data = Preprocess.solve_data(data)
#     Preprocess.save_tokenlization_result(data, target)
#     Preprocess.vectword()
#     data, target = TrainData.load()
#     _path = "./model/NaiveBayesian.pkl"
#     cls = joblib.load(_path)
#     res = cls.predict(data[-1])
#     return res


if __name__ == '__main__':
    data, target = Preprocess.read_train_data()
    for item in range(0, 10):
        label = test_label(target, item)
        Preprocess.save_tokenlization_result_target(label, item)
    while True:
        inputtxt = input("请输入你的评论：")

        #处理数据
        data, target = Preprocess.read_train_data()
        inputtxt = inputtxt.strip()
        data.append(inputtxt)
        data = Preprocess.solve_data(data)
        Preprocess.save_tokenlization_result_data(data)
        Preprocess.vectword()

        res = []
        for item in range(0,10):
            res_data = predict(item)
            res.append(res_data)
        print(res)