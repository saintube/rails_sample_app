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
import os

dir_path = os.path.dirname(os.path.abspath(__file__))

def save(model, filename=None):
    default_path = dir_path+'/model/train_data.pkl'
    joblib.dump(model, filename if filename else default_path)

def load_model(model,filename=None):
    default_path = dir_path+'/model/train_data.pkl'
    with open(model) as f:
        return joblib.load(filename if filename else default_path), list(map(int, f.read().split('\n')[:-1]))

def load(idx,filename=None):
    default_path = dir_path+'/model/train_data.pkl'
    with open(dir_path+'/data/tags_token_results' + '_tag'+str(idx)) as f:
        return joblib.load(filename if filename else default_path), list(map(int, f.read().split('\n')[:-1]))