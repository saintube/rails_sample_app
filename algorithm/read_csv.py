# -*- coding: utf-8 -*-
"""
Created on Sun Dec 23 17:01:40 2018

@author: WangWenming
"""

import csv


         

     
   
if __name__ == '__main__': 
   data=[]
   target=[]
   csv_reader = csv.reader(open('./data/train.csv', encoding='utf-8'))
   for row in csv_reader:
       data.append(row[1])
       target.append(row[3])
   print(target)
