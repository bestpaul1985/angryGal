#pragma once
#include "ofMain.h"

class gal{
public:
    
    ofImage galImage[5];
    ofImage *leftHandImage[3];
    ofImage *rightHandImage[3];
    int lastTime;
    int leftNum, rightNum;
    bool bLeftHand,bRightHand;
    bool bShot;
    float offSet;
    
    gal(){
        leftNum = 0;
        rightNum = 0;
        bShot = false;
        bLeftHand = false;
        bRightHand = false;
    }
    
    void set(){
        
        galImage[0].loadImage("image/galBACK2.png");
        galImage[1].loadImage("image/galBACK3.png");
        galImage[2].loadImage("image/galBACK4.png");
        galImage[3].loadImage("image/galBACK5.png");
        galImage[4].loadImage("image/galBACK6.png");
        
        leftHandImage[0]= &galImage[0];
        leftHandImage[1]= &galImage[3];
        leftHandImage[2]= &galImage[4];
        
        rightHandImage[0]= &galImage[0];
        rightHandImage[1]= &galImage[1];
        rightHandImage[2]= &galImage[2];
        
    }
    
    void draw(){
    
        ofSetColor(255);
        ofPushMatrix();
        ofTranslate(ofGetWidth()/2, ofGetHeight()-70);
        if (ofGetElapsedTimeMillis() -lastTime >70) {
            if(bLeftHand){
                leftNum++;
            }else if(bRightHand){
                rightNum++;
            }
            lastTime =ofGetElapsedTimeMillis();
        }
        

        if (leftNum>2 || rightNum>2) {
            leftNum = 0;
            rightNum = 0;
            bLeftHand = false;
            bRightHand = false;
        }
        
        if (bLeftHand) {
            leftHandImage[leftNum]->draw(-leftHandImage[leftNum]->getWidth()/2 + offSet, -leftHandImage[leftNum]->getHeight()/2);
        }
        
        else if(bRightHand){
            rightHandImage[rightNum]->draw(-rightHandImage[rightNum]->getWidth()/2 + offSet, -rightHandImage[rightNum]->getHeight()/2);

        }else{
            rightHandImage[0]->draw(-rightHandImage[rightNum]->getWidth()/2 + offSet, -rightHandImage[rightNum]->getHeight()/2);

        }
        
        ofPopMatrix();
    }
    
};