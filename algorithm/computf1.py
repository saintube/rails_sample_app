# -*- coding: utf-8 -*-
"""
Created on Sun Dec 23 19:20:04 2018

@author: WangWenming
"""

from sklearn.metrics import precision_score, recall_score, f1_score
 
y_true = [0, 1, 1, 0, 1, 0]
y_pred = [1, 1, 1, 0, 0, 1]
 
p = precision_score(y_true, y_pred, average='binary')
r = recall_score(y_true, y_pred, average='binary')
f1score = f1_score(y_true, y_pred, average='binary')
 
print(p)
print(r)
print(f1score)
