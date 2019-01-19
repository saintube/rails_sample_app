# -*- coding: utf-8 -*-
"""
Created on Sun Dec 23 18:34:48 2018

@author: WangWenming
"""

import sys  
import time  
from sklearn import metrics  
from sklearn.naive_bayes import BernoulliNB
from sklearn.model_selection import train_test_split
import numpy as np
from scipy import sparse, io
import _pickle as cPickle
import importlib
from model_manage import TrainData

import pandas as pd
import numpy as np

importlib.reload(sys)

 
# KNN Classifier  
def knn_classifier(train_x, train_y):  
    from sklearn.neighbors import KNeighborsClassifier  
    model = KNeighborsClassifier()  
    model.fit(train_x, train_y)  
    return model  
  
  
# Logistic Regression Classifier  
def logistic_regression_classifier(train_x, train_y):  
    from sklearn.linear_model import LogisticRegression  
    model = LogisticRegression(penalty='l2')  
    model.fit(train_x, train_y)  
    return model  
  
  
# Random Forest Classifier  
def random_forest_classifier(train_x, train_y):  
    from sklearn.ensemble import RandomForestClassifier  
    model = RandomForestClassifier(n_estimators=8)  
    model.fit(train_x, train_y)  
    return model  
  
  
# Decision Tree Classifier  
def decision_tree_classifier(train_x, train_y):  
    from sklearn import tree  
    model = tree.DecisionTreeClassifier()  
    model.fit(train_x, train_y)  
    return model  
  
  
# GBDT(Gradient Boosting Decision Tree) Classifier  
def gradient_boosting_classifier(train_x, train_y):  
    from sklearn.ensemble import GradientBoostingClassifier  
    model = GradientBoostingClassifier(n_estimators=200)  
    model.fit(train_x, train_y)  
    return model  
  
# SVM Classifier using cross validation  
def svm_cross_validation(train_x, train_y):  
    from sklearn.grid_search import GridSearchCV  
    from sklearn.svm import SVC  
    model = SVC(kernel='rbf', probability=True)  
    param_grid = {'C': [1e-3, 1e-2, 1e-1, 1, 10, 100, 1000], 'gamma': [0.001, 0.0001]}  
    grid_search = GridSearchCV(model, param_grid, n_jobs = 1, verbose=1)  
    grid_search.fit(train_x, train_y)  
    best_parameters = grid_search.best_estimator_.get_params()  
    for para,val in best_parameters.items():  
        print (para,val)
    model = SVC(kernel='rbf', C=best_parameters['C'], gamma=best_parameters['gamma'], probability=True)  
    model.fit(train_x, train_y)  
    return model  

# Multinomial Naive Bayes Classifier  
def multinomial_naive_bayes_classifier(train_x, train_y):  
    from sklearn.naive_bayes import MultinomialNB  
    model = MultinomialNB(alpha=0.01)  
    model.fit(train_x, train_y)  
    return model  

# Bernoulli Naive Bayes Classifier  
def bernoulli_naive_bayes_classifier(train_x, train_y):  
    from sklearn.naive_bayes import MultinomialNB  
    model = BernoulliNB(alpha=0.01)
    model.fit(train_x, train_y)  
    return model  
  
 

# how much train data, how much test data
def select_data(x, y, takeup):
    train_x, test_x, train_y, test_y = train_test_split(
        x, y, test_size=takeup, random_state=20) #test data take up takeup, random_seed is 20
    return train_x, test_x, train_y, test_y

if '__main__' == __name__:
    # how much test data take up
    # 0.1 indicates test data take up 10%
    subject=['power', 'price', 'interior', 'configuration', 'safety', 'appearance', 'handling', 'fuel', 'space', 'comfort']
    for sub in subject:
        takeup = 0.1
        save_price_path='./data/tags_'+sub+'_results'
        x, y = TrainData.load(save_price_path + '_tag','./model/'+sub+'_train_data.pkl')
        col=x.shape[0]
        target_length=len(y)
        print(col)
        print(target_length)
        if col>target_length:
            distance=target_length-col
            x=x[:distance]
        
        train_x, test_x, train_y, test_y = select_data(x, y, takeup)
        print(train_x)
        print(train_y)
        print(test_x)
        print(test_y)
    
        
        test_classifiers = ['DT']
        #test_classifiers = ['SVM']
    #    test_classifiers = ['MultinomialNB','BernoulliNB']
        classifiers = { 
                        'KNN':knn_classifier,  
                        'LR':logistic_regression_classifier,  
                        'RF':random_forest_classifier,  
                        'DT':decision_tree_classifier, 
                        'GBDT':gradient_boosting_classifier,
                        'SVM':svm_cross_validation,
                        'MultinomialNB':multinomial_naive_bayes_classifier,  
                        'BernoulliNB':bernoulli_naive_bayes_classifier
        }  
        model_save = {} 
    
    
        for classifier in test_classifiers: 
            print ('******************* %s ********************' % classifier)
            start_time = time.time()  
            model = classifiers[classifier](train_x, train_y)  
            print ('training took %fs!' % (time.time() - start_time))
            TrainData.save(model,'./model_classifiers/model'+sub+'_'+classifier+'.pkl')
    
            # Predict the test x
            predict = model.predict(test_x)
            predict=predict.tolist()
            print(predict)
            print(metrics.accuracy_score(test_y, predict))
#        print(metrics.precision_score(test_y, predict))
#        print(test_y)
#        Measurement
#        precision = metrics.precision_score(test_y, predict,pos_label=1,average=None) #string u'1'
#        recall = metrics.recall_score(test_y, predict, pos_label= u'1')
#        print(precision)
#        print(recall)
#        print ('precision: %.2f%%, recall: %.2f%%' % (100 * precision, 100 * recall))
#        accuracy = metrics.accuracy_score(test_y, predict)  
#        print ('accuracy: %.2f%%' % (100 * accuracy))
#
#        print('RESULT')
#        print(metrics.classification_report(test_y, predict))
