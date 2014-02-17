#pragma once
#include "ofMain.h"

class gal{
public:
    
    ofImage galBack[3];
    int lastTime;
    int leftNum;
    bool bLeftHand;
    bool bButtletLeft;
    float offSet;
    gal(){
        leftNum = 0;
        bLeftHand = false;
        bButtletLeft = false;
    }
    
    void set(){
        lastTime =ofGetElapsedTimeMillis();
        galBack[0].loadImage("image/galBACK2.png");
        galBack[1].loadImage("image/galBACK3.png");
        galBack[2].loadImage("image/galBACK4.png");

    }
    
    void draw(){
    
        ofSetColor(255);
        ofPushMatrix();
        ofTranslate(ofGetWidth()/2, ofGetHeight()-70);
       
        if (bLeftHand) {
            
            if (ofGetElapsedTimeMillis() -lastTime >70) {
                leftNum++;
                lastTime =ofGetElapsedTimeMillis();
            }

            if (leftNum>2) {
                leftNum = 0;
                bLeftHand = false;
            }
            
        }
        
        galBack[leftNum].draw(-galBack[leftNum].getWidth()/2 + offSet, -galBack[leftNum].getHeight()/2);
        ofPopMatrix();
    }
    
};