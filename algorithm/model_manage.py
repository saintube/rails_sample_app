# -*- coding: utf-8 -*-
"""
Created on Sun Dec 23 15:22:34 2018

@author: WangWenming
"""
from sklearn.externals import joblib

class TrainData(object):
    default_path = './model/train_data.pkl'

    @staticmethod
    def save(model, filename=None):
        joblib.dump(model, filename if filename else TrainData.default_path)

    @staticmethod
    def load(targetfile,filename=None):
        with open(targetfile) as f:
            return joblib.load(filename if filename else TrainData.default_path), list(map(int, f.read().split('\n')[:-1]))