# -*- coding: utf-8 -*-
"""
Created on Tue Dec 18 22:22:29 2018

@author: WangWenming
"""
import jieba
from collections import Counter
from sklearn.feature_extraction import DictVectorizer
import codecs
from model_manage import TrainData

def read_data():
    file_path="./data/hs.txt"
    target=[]
    data=[]
    with codecs.open(file_path,'r') as f:
        for line in f.read().split('\n')[:-1]:
            line = line.strip()
            target.append(line[0])
            data.append(line[1:].lstrip())
    return  data,target


def save_result(data,target,file_path='./data/tags_token_results'):
    with codecs.open(file_path,'w') as f:
        for x in data:
            f.write(' '.join(x)+'\n')
    with codecs.open(file_path+'_tag','w') as f:
        for y in target:
            f.write(y+'\n')
            
    
    

if __name__ == '__main__':
    txtdata,target=read_data()
    data=[]
    for txt_item in txtdata:
        str1=jieba.lcut(txt_item)
        data.append(str1)
    save_result(data,target)
    with codecs.open('./data/tags_token_results', 'r') as f:
        data = [line.strip().split() for line in f.read().split('\n')]
        if not data[-1]: data.pop()
        t=[Counter(d) for d in data ]
        print(t)
        v=DictVectorizer()
        t=v.fit_transform(t) #稀疏矩阵 词篇好
        TrainData.save(t)
        
    



        
    
    