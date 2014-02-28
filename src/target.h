#pragma once
#include "ofMain.h"

class target{
public:
    
    ofPoint             orgPos,trun01,trun02,pos,endPos;
    ofPoint             door[6];
    vector<ofPoint>     points;
    bool                bRemove;
    ofRectangle         body;
    float               w,h;
    float               scale;
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
        scale = 0;
        w = 50;
        h = 100;
        body.set(140,168, 100*0.2, 150*0.2);
        pct = 0;
        vel = 0.01;
        timer1 = 0;
        num = 0;
        
        door[0].set(140,168,0.2);
        door[1].set(210,191,0.5);
        door[2].set(99,225,0.6);
        door[3].set(257,253,0.7);
        door[4].set(24,300,0.8);
        door[5].set(319,395,1);
        
        
    }
    
    void set(){
        bRemove = false;
//        trun01.set(ofGetWidth()/2, orgPos.y);
//        trun02.set(trun01.x, endPos.y);
//        
//        points.push_back(orgPos);
//        points.push_back(trun01);
//        points.push_back(trun02);
//        points.push_back(endPos);
        
        for (int i=0; i<6; i++) {
            points.push_back(door[i]);
        }
        
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
        scale = (1-pct)*points[num].z + pct*points[num+1].z;
        
        body.setFromCenter(pos.x,pos.y,w*scale,h*scale);
    }
    
    void draw(){
        
        ofSetColor(255, 0, 0);
        ofRect(body);
        
        ofSetColor(255, 0,200);
        ofCircle(pos.x, pos.y, 25*scale);
    }
    
    void bounceOffWalls(){
        
        
    }
    
};