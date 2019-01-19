# -*- coding: utf-8 -*-
"""
Created on Sat Jan  5 09:56:03 2019

@author: WangWenming
"""
import numpy as np

def getWeight(X):
    print(X)
    X= np.array(X)
    print(X)
    print(type(X))
    col=X.shape[1]
    num=[0 for i in range(col)]
    w=[0 for i in range(col)]
    w=np.array(w).T
    print(w)
    while True:
        for i in range(X.shape[0]):
            s=np.dot(w,X[i,:].T)
            print(s)
            a=i%col
            if s<=0:
                w+=X[i,:]
                print(w)
                num[a]=0
            else:
                print(w)
                num[a]=1
            for j in range(col):
                if num[j]!=1:
                    break
                if num[col-1]==1:
                    return w

if '__main__' == __name__:
    X=[]
    for k in range(2):
        print("请输入x"+str(k)+"样本的维数和数量:")
        dims=int(input())
        n1=int(input())
        print("请输入x"+str(k)+"样本:")
        for i in range(n1):
            row=input()
            row=row.strip().split(' ')
            for q in range(dims):
                if k==1:
                    row[q]=-int(row[q])
                    if q==dims-1:
                        row.append(-1)
                else:
                    row[q]=int(row[q])
                    if q==dims-1:
                        row.append(1)
            X.append(row)
    getWeight(X)
    
        
        
            
    
    
    
        
                