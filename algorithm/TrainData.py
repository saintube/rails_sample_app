#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   TrainData.py    
@Contact :   raogx.vip@hotmail.com
@License :   (C)Copyright 2017-2018, Liugroup-NLPR-CASIA

@Modify Time      @Author    @Version    @Desciption
------------      -------    --------    -----------
2019-01-08 11:44   yeweiyang      1.0         None
'''

# import lib
from sklearn.externals import joblib

def save(model, filename=None):
    default_path = './model/train_data.pkl'
    joblib.dump(model, filename if filename else default_path)

def load(idx,filename=None):
    default_path = './model/train_data.pkl'
    with open('./data/tags_token_results' + '_tag'+str(idx)) as f:
        return joblib.load(filename if filename else default_path), list(map(int, f.read().split('\n')[:-1]))