#pragma once
#include "ofMain.h"

class target{
public:
    
    ofPoint             orgPos,trun01,trun02,pos,endPos;
    ofPoint             door[6];
    vector<ofPoint>     points;
    bool                bRemove;
    float               orgSize,size;
    float               pct,vel;
    float               timer1;
    int                 num;
    
    float map(float value, float inMin, float inMax, float outMin, float outMax, float shaper){
        float pct = ofMap (value, inMin, inMax, 0, 1, true);
        pct = powf(pct, shaper);
        float out = ofMap(pct, 0,1, outMin, outMax, true);
        return out;
    }
    
    target(){
        
        bRemove = false;
        orgSize = 15;
        size = 15;
        pct = 0;
        vel = 0.02;
        timer1 = 0;
        num = 0;
        
        door[0].set(140,168);
        door[1].set(96,198);
        door[2].set(35,230);
        door[3].set(210,183);
        door[4].set(265,202);
        door[5].set(317,269);
        
        
    }
    
    void set(){
        bRemove = false;

        trun01.set(ofGetWidth()/2, orgPos.y);
        trun02.set(trun01.x, endPos.y);
        
        points.push_back(orgPos);
        points.push_back(trun01);
        points.push_back(trun02);
        points.push_back(endPos);
        
    }
    
    void update(){
        
        pct+=vel;
        if (pct > 1) {
            num ++;
            if (num>(points.size()-2)) {
                num = 0;
                pct = 0;
            }else{
                pct = 0;
            }
        }
        
        pos.x = (1-pct)*points[num].x + pct*points[num+1].x;
        pos.y = (1-pct)*points[num].y + pct*points[num+1].y;

        
    }
    
    void draw(){
        
        ofSetColor(255, 0, 0);
        ofCircle(pos.x,pos.y, orgSize);
    }
    
    void bounceOffWalls(){
        
        
    }
    
    
};