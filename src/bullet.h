#pragma once
#include "ofMain.h"
#include "particle.h"

class bullet{

public:
    
    ofPoint     pos, vel, attraPos;
    particle    myBullet;
    ofPoint     sizeRange;
    bool        bRemove;
    float       size;
    float       orgW;
    float       orgH;
    float       w,h;
    int         flyDis;
    float       attractScale;
    ofImage*    kknife[8];
    int         timer;
    int         num;
    
    bullet(){
        size = 20;
        flyDis = 250;
        attraPos.set(150, 240);
        bRemove = false;
        attractScale = 1;
        orgW = 13;
        orgH = 60;
        num = 0;
        timer = ofGetElapsedTimeMillis();
    }
    
    void set(){
        myBullet.setInitialCondition(pos.x, pos.y, vel.x, vel.y);
    }
    
    void update(){
        myBullet.resetForce();
        myBullet.addAttractionForce(attraPos.x, attraPos.y, 600, attractScale);
        myBullet.addDampingForce();
        myBullet.update();
        
        //check the bullet fly distance, if it is
        //further than  the limit, remove this bullet
        float dis = attraPos.distance(myBullet.pos);
        if( dis < 10){
            bRemove = true;
        }
        
        w = ofMap( myBullet.pos.y ,ofGetHeight()-80, attraPos.y, orgW, orgW/1.5, true);
        h = ofMap( myBullet.pos.y ,ofGetHeight()-80, attraPos.y, orgH, orgH/1.5, true);
        
    }
    
    void draw(){
        
//        ofSetColor(255, 0, 0);
//        ofCircle(attraPos.x,attraPos.y,6);

        
        if (ofGetElapsedTimeMillis()-timer>100) {
            num++;
            if (num > 7) {
                num = 0;
            }
        }
        
        ofSetColor(255);
        ofPushMatrix();
        ofTranslate(myBullet.pos.x, myBullet.pos.y);
        kknife[num]->draw(-kknife[num]->getWidth()/2, -kknife[num]->getHeight()/2, w, h);
        ofPopMatrix();
        
    }
    
};

